# 🌌 Booru-Scraper

[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg)](https://unlicense.org/)
[![Bash](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Fast](https://img.shields.io/badge/Speed-Pipelined-orange.svg)](https://github.com/lynnux-useless-codes/rule34-Scraper)

A high-performance, modular, and asynchronous bash-based scraper for Booru-style imageboards. Designed for speed, flexibility, and ease of use.

## ✨ Features

- **🚀 Pipelined Execution**: Asynchronous metadata fetching and file downloading ensures maximum bandwidth saturation.
- **🧵 Multi-threaded**: High-speed parallel downloads with configurable thread limits.
- **🔄 Unlimited Downloading**: Support for downloading all available results using `amount: 0`, `-1`, or `*`.
- **🧩 Modular Drivers**: Easily extendable with site-specific drivers (Rule34, Gelbooru, Safebooru, etc.).
- **💎 Premium CLI UI**: Real-time progress bars, animated loading spinners, and color-coded logging.
- **💾 Smart Caching**: Optional SHA-256 hash checking to prevent redundant downloads.
- **⚙️ Flexible Config**: Load settings from `config.yaml` or override them via command-line arguments.

## 🛠️ Installation

```bash
# Clone the repository
git clone https://github.com/lynnux-useless-codes/Booru-Scraper.git

# Enter the directory
cd Booru-Scraper

# Grant execution permissions
chmod +x downloader.sh
```

## 🚀 Quick Start

### Basic Download
Download 20 images with specific tags:
```bash
./downloader.sh --amount 20 "sombra"
```

### Download All Available
Download everything matching a tag:
```bash
./downloader.sh --amount 0 "tracer"
```

### Using Site Drivers
Specify a different imageboard (e.g., Safebooru):
```bash
./downloader.sh --site safebooru --amount 10 "solo"
```

## 📂 Documentation

Detailed guides for various aspects of the scraper can be found in the `docs/` directory:

- [📖 Usage Guide](docs/usage.md) - Comprehensive command line examples and tips.
- [⚙️ Configuration](docs/configuration.md) - Detailed breakdown of `config.yaml` options.
- [🛠️ Extending](docs/site_drivers.md) - How to add support for new Booru sites.

## 📋 Prerequisites

Ensure your system has the following utilities installed:
- `bash` (v4.0+)
- `curl`
- `jq`
- `sha256sum`

## 🏗️ Project Structure

```text
.
├── downloader.sh       # Main entry point
├── config.yaml         # User configuration
├── docs/               # Advanced documentation
└── src/
    ├── core/           # Engine and config modules
    ├── sites/          # Site-specific drivers
    └── utils/          # Progress, logging, and helpers
```

## 📜 License

This project is released into the public domain under the [Unlicense](LICENSE). Feel free to use, modify, and distribute without any restrictions.
