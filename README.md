# 🎬 Emby GPUI Client

A GPU-accelerated desktop client for Emby Media Server, built with Rust and modern UI frameworks.

![Platform](https://img.shields.io/badge/Platform-Windows%2010%2F11-blue?style=flat-square)
![Language](https://img.shields.io/badge/Language-Rust%202024-orange?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

## ⚡ Features

- 🖥️ **GPU-Accelerated Rendering** - Modern Fluent Design with Mica/Acrylic materials
- 🎬 **Hardware Video Decoding** - DirectPlay support via mpv (D3D11VA, DXVA2, QSV)
- 🌐 **Multi-Server Support** - Automatic deduplication across multiple Emby servers
- 🔒 **Secure OAuth 2.0** - PKCE-based PIN login with AES-GCM encrypted storage
- 📊 **Smart Analytics** - GitHub-style activity heatmaps and statistics
- 🍿 **WatchParty Sync** - Real-time collaborative viewing sessions

## 🚀 Quick Start

### Windows Installation

Download the latest installer from [Releases](https://github.com/YOUR_USERNAME/emby-gpui-client/releases):

```bash
# Or build from source:
cargo build --release
.\target\release\emby-gpui.exe
```

## 🛠️ Development Setup

### Prerequisites

- Rust 1.80+ (`rustup install stable`)
- Visual Studio Build Tools (Windows only)
- MPV Player (optional, for video playback)

### Building

```bash
# Clone repository
git clone https://github.com/228659/emby-gpui-client.git
cd emby-gpui-client

# Build release version
cargo build --release --target x86_64-pc-windows-msvc

# Run tests
cargo test --lib

# Package distribution
.\build.ps1
```

## 📚 Architecture

```
emby-gpui-client/
├── src/                    # Main source code
│   ├── main.rs            # Application entry point
│   ├── state/             # State management & caching
│   │   └── cache_engine.rs
│   ├── api/               # Emby API integration
│   │   └── emby_client.rs
│   ├── features/          # Advanced features
│   │   ├── multi_server/
│   │   ├── intro_skipper/
│   │   └── trakt_sync/
│   └── ui/                # GPU UI components
│       └── views/
├── .github/workflows/     # CI/CD pipeline
├── TESTING_AND_BUILD_GUIDE.md
└── build.ps1
```

## 🎯 Roadmap

- [x] Core architecture design
- [x] Authentication & API integration  
- [x] SQLite caching engine
- [x] UI component system
- [x] Hardware accelerated playback
- [ ] Multi-server deduplication
- [ ] TheIntroDB skip integration
- [ ] Trakt.tv two-way sync
- [ ] WatchParty real-time sync
- [ ] Android/iOS porting (WGPU backend)

## 🤝 Contributing

Contributions are welcome! Please read our contribution guidelines before submitting PRs.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Built with ❤️ using Rust + Modern UI**
