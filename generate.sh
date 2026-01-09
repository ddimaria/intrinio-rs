#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "==> Converting Swagger 2.0 to OpenAPI 3.0..."
npx --yes swagger2openapi open_api_spec.json -o open_api_spec_v3.json --patch

echo "==> Fixing OpenAPI spec for progenitor compatibility..."
python3 << 'EOF'
import json

with open('open_api_spec_v3.json', 'r') as f:
    spec = json.load(f)

def dedupe_enums(obj):
    """Remove duplicate values from enum arrays."""
    if isinstance(obj, dict):
        for key, value in obj.items():
            if key == 'enum' and isinstance(value, list):
                seen = set()
                deduped = []
                for item in value:
                    if item not in seen:
                        seen.add(item)
                        deduped.append(item)
                obj[key] = deduped
            else:
                dedupe_enums(value)
    elif isinstance(obj, list):
        for item in obj:
            dedupe_enums(item)

def fix_types(obj):
    """Fix invalid JSON Schema types."""
    if isinstance(obj, dict):
        # Fix "type": "date" -> "type": "string", "format": "date"
        if obj.get('type') == 'date':
            obj['type'] = 'string'
            obj['format'] = 'date'
        # Fix "type": "float" -> "type": "number"
        elif obj.get('type') == 'float':
            obj['type'] = 'number'
        
        for value in obj.values():
            fix_types(value)
    elif isinstance(obj, list):
        for item in obj:
            fix_types(item)

def fix_enum_conflicts(obj):
    """Fix enum values that conflict when converted to Rust (e.g., m1 vs M1)."""
    if isinstance(obj, dict):
        for key, value in obj.items():
            if key == 'enum' and isinstance(value, list):
                # Check for m1/M1 conflict (minute vs month intervals)
                if 'm1' in value and 'M1' in value:
                    obj[key] = [
                        'min1' if v == 'm1' else
                        'min5' if v == 'm5' else
                        'min15' if v == 'm15' else
                        'min30' if v == 'm30' else
                        'Mo1' if v == 'M1' else v
                        for v in value
                    ]
            else:
                fix_enum_conflicts(value)
    elif isinstance(obj, list):
        for item in obj:
            fix_enum_conflicts(item)

def fix_misplaced_descriptions(obj, parent_key=None):
    """Fix description fields that are incorrectly placed as properties."""
    if isinstance(obj, dict):
        if 'properties' in obj and isinstance(obj['properties'], dict):
            props = obj['properties']
            # Check for bare string "description" that should be inside another property
            if 'description' in props and isinstance(props['description'], str):
                # This is a bug - description as a property with just a string value
                # Try to find the property it belongs to and move it there
                desc_value = props.pop('description')
                # Look for array properties that might be missing a description
                for prop_name, prop_value in props.items():
                    if isinstance(prop_value, dict) and prop_value.get('type') == 'array':
                        if 'description' not in prop_value:
                            prop_value['description'] = desc_value
                            break
        
        for key, value in obj.items():
            fix_misplaced_descriptions(value, key)
    elif isinstance(obj, list):
        for item in obj:
            fix_misplaced_descriptions(item, parent_key)

# Apply all fixes
print("  - Fixing invalid types (date, float)...")
fix_types(spec)

print("  - Fixing enum naming conflicts...")
fix_enum_conflicts(spec)

print("  - Deduplicating enum values...")
dedupe_enums(spec)

print("  - Fixing misplaced description fields...")
fix_misplaced_descriptions(spec)

with open('open_api_spec_v3.json', 'w') as f:
    json.dump(spec, f, indent=4)

print("  Done!")
EOF

echo "==> Generating Rust client with progenitor..."
rm -rf .gen
cargo progenitor -i open_api_spec_v3.json -o .gen -n intrinio-rs -v 0.1.0

echo "==> Copying generated lib.rs to src/..."
cp .gen/src/lib.rs src/lib.rs

echo "==> Cleaning up..."
rm -rf .gen

echo "==> Done! Generated src/lib.rs"

