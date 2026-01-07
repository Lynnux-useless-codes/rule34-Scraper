# Booru-Scraper

A powerful, modular, and fast bash-based scraper for multiple Booru-style imageboards. It supports multi-threaded downloads, filtering, and caching across various sites with [rule34.xxx](https://rule34.xxx) as the default.

## 🚀 Features

- **Multi-threaded**: Download multiple files simultaneously for maximum speed.
- **Modular Architecture**: Clean code structure with separate modules for logging, utilities, config, and core engine.
- **Advanced Filtering**: Choose to download only images, only videos/GIFs, or everything.
- **Smart Caching**: Optional SHA-256 hash-based caching to avoid re-downloading existing files.
- **Flexible Configuration**: Support for both command-line arguments and YAML-based config files.
- **Beautiful Logs**: Color-coded, timestamped logging for easy monitoring.

## 📋 Prerequisites

Ensure you have the following installed:

- `bash` (v4.0+)
- `curl`
- `jq`
- `sha256sum` (usually part of `coreutils`)

## 🛠️ Installation

```bash
git clone https://github.com/lynnux-useless-codes/Booru-Scraper.git
cd Booru-Scraper
chmod +x downloader.sh
```

## 📖 Usage

### Command Line

```bash
./downloader.sh [options] "tags"
```

#### Options

- `-h, --help`: Show help message and exit.
- `--debug`: Enable verbose debug logging.
- `--config <file>`: Path to a YAML configuration file.
- `--pages <count>`: Number of pages to download from the API.
- `--amount <count>`: Total number of images to download.
- `--only-videos`: Only download videos and GIFs.
- `--only-images`: Only download images (jpg, jpeg, png, gif).
- `--cache-hash`: Enable SHA-256 hash checking to skip already downloaded files.
- `--api-key <key>`: API key for the selected site (e.g., rule34.xxx or gelbooru.com).
- `--user-id <id>`: User ID for the selected site.
- `--site <name>`: Site to scrape (default: `rule34`). Supported: `rule34`, `xbooru`, `hypnohub`, `konachan`, `safebooru`, etc.

> [!IMPORTANT]
> Sites like rule34.xxx and gelbooru.com require a User ID and API key.
> You can typically find these in your account options/settings on the respective site.

### Config File (`config.yaml`)
You can also use a YAML file for persistent settings:
```yaml
tags: "solo high_res"
max_threads: 10
image_folder: "my_downloads"
amount: 50
rule34_api_key: "your_r34_key"
rule34_user_id: "your_r34_id"
gelbooru_api_key: "your_gelbooru_key"
gelbooru_user_id: "your_gelbooru_id"
```

## 📂 Project Structure

```text
.
├── downloader.sh       # Main entry point
├── config.yaml         # Example configuration
├── LICENSE             # Unlicense (Public Domain)
└── src/
    ├── core/
    │   ├── config.sh   # Configuration & Defaults
    │   └── engine.sh   # Core downloading logic
    └── utils/
        ├── helpers.sh  # Utility functions
        └── logger.sh   # Logging & UI colors
```

## 📜 License

This project is released into the public domain under the [Unlicense](LICENSE).