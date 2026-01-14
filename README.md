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
    // Create a new client with your API key
    let client = Client::new("https://api-v2.intrinio.com", "YOUR_API_KEY");
    
    // Get company information
    let company = client
        .get_company()
        .identifier("AAPL")
        .send()
        .await?;
    
    println!("Company: {:?}", company);
    
    Ok(())
}
```

### Authentication

The Intrinio API requires an API key for authentication. Pass your API key to `Client::new()` and it will be automatically added to all requests:

```rust
use intrinio_rs::Client;

let client = Client::new("https://api-v2.intrinio.com", "YOUR_API_KEY");

// Only specify the parameters you need
let companies = client
    .get_all_companies()
    .sector("Technology")
    .has_stock_prices(true)
    .page_size(100)
    .send()
    .await?;
```

## Features

- **Company Data** - Reference data, metadata, and daily metrics
- **Financial Statements** - Standardized and as-reported fundamentals, XBRL notes
- **Stock Prices** - Real-time quotes, historical EOD, and intraday prices
- **Options** - Real-time and historical options data, chains, prices, and Greeks
- **ETFs** - Holdings, NAV, flows, and returns analytics
- **Indices** - Index prices, constituents, and historical data
- **Insider & Institutional Holdings** - Ownership data and transactions
- **SEC Filings** - Raw text filings and structured data
- **IPOs** - Upcoming and historical IPO data
- **ESG** - Environmental, social, and governance scores
- **Forex** - Currency pair prices and historical data
- **Economic Data** - Macroeconomic indicators and time series
- **Municipalities** - Municipal bond and financial data
- **Technical Indicators** - 50+ indicators (SMA, EMA, RSI, MACD, Bollinger Bands, etc.)
- **Company News** - News articles and sentiment
- **Thea AI** - AI-powered natural language answers about financial data
- **Screener** - Filter and screen securities
- **Bulk Downloads** - Batch data downloads

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
