# intrinio-rs

A Rust SDK for interacting with the [Intrinio API](https://intrinio.com/). This client library is automatically generated from the Intrinio OpenAPI specification using [progenitor](https://github.com/oxidecomputer/progenitor).

## Overview

Intrinio is a financial data platform providing access to stock prices, fundamentals, SEC filings, ETF data, options, forex, crypto, and more. This SDK provides a type-safe Rust interface to interact with all Intrinio API endpoints.

## Installation

Add this to your `Cargo.toml`:

```toml
[dependencies]
intrinio-rs = "0.1.0"
```

## Usage

### Basic Example

```rust
use intrinio_rs::Client;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Create a new client
    let client = Client::new("https://api-v2.intrinio.com");
    
    // Get company information (API key passed as query parameter)
    let company = client
        .get_company("AAPL", Some("your_api_key"))
        .await?;
    
    println!("Company: {:?}", company);
    
    Ok(())
}
```

### Authentication

The Intrinio API uses an API key passed as a query parameter (`api_key`). Most methods accept an optional `api_key` parameter:

```rust
use intrinio_rs::Client;

let client = Client::new("https://api-v2.intrinio.com");

// Pass your API key to each request
let companies = client
    .get_all_companies(
        None,  // latest_filing_date
        None,  // sic
        None,  // template
        None,  // sector
        None,  // industry_category
        None,  // industry_group
        None,  // has_fundamentals
        None,  // has_stock_prices
        None,  // thea_enabled
        None,  // page_size
        None,  // next_page
        Some("your_api_key"),
    )
    .await?;
```

## Features

- **Stock Data** - Real-time and historical stock prices, quotes, and trading data
- **Company Fundamentals** - Financial statements, ratios, and company metrics
- **SEC Filings** - Access to 10-K, 10-Q, 8-K, and other SEC filings
- **ETF Data** - ETF holdings, NAV, flows, and analytics
- **Options** - Options chains, prices, and Greeks
- **Forex & Crypto** - Currency pairs and cryptocurrency market data
- **Technical Indicators** - SMA, EMA, RSI, MACD, and 50+ other indicators
- **News** - Company news and sentiment analysis

## Dependencies

- `progenitor-client` - Core client functionality
- `reqwest` - HTTP client
- `serde` / `serde_json` - Serialization
- `chrono` - Date/time handling
- `bytes` / `futures-core` - Async streaming support

## Development

### Regenerating the Client

The client is generated from Intrinio's OpenAPI specification. To regenerate:

```bash
./generate.sh
```

This script:
1. Converts the Swagger 2.0 spec to OpenAPI 3.0
2. Applies fixes for progenitor compatibility
3. Generates the Rust client code

### Building

```bash
cargo build
```

### Running Tests

```bash
cargo test
```

## Documentation

- [Intrinio API Documentation](https://docs.intrinio.com/documentation/api_v2)
- [Rust SDK Documentation](https://docs.rs/crate/intrinio-rs/latest)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Disclaimer

This is an unofficial SDK. For official Intrinio support, please visit [Intrinio](https://intrinio.com/).

## Related Projects

- [progenitor](https://github.com/oxidecomputer/progenitor) - The OpenAPI client generator used to create this SDK
