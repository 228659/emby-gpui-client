# Emby GPUI Client

**GPU-accelerated native Emby desktop client powered by Rust and GPUI**

## Features

- ⚡ **High Performance**: Built with Rust and GPUI for maximum efficiency
- 🎬 **DirectPlay**: Hardware-accelerated video playback via MPV
- 🌐 **Multi-Server Support**: Unified library across multiple Emby servers
- 📊 **Smart Caching**: SQLite WAL mode for fast local caching
- 🔒 **Secure Auth**: OAuth 2.0 PKCE authentication flow

## Quick Start

```bash
# Install dependencies
cargo install gpui --path ./vendor/gpui

# Build release version
cargo build --release --target x86_64-pc-windows-msvc

# Run locally
cargo run
```

## Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md) for complete design documentation.

## License

MIT License - See LICENSE for details
