# ⚙️ Configuration

Booru-Scraper supports various configuration options via CLI flags or a `config.yaml` file.

## `config.yaml` Reference

A `config.yaml` file in the current directory (or its example counterpart `config.example.yaml`) allows you to persist your settings.

```yaml
# Search parameters
tags: "Example+Tag"      # Default search tags (Multiple tags can pe given with the + sign as divider)
amount: 100              # Total items to download (0 for all)

# Engine settings
max_threads: 10          # Simultaneous downloads
image_folder: "downloads" # Destination folder

# Boolean flags (true/false)
cache_hash: true         # Enable SHA-256 caching
only_images: false       # Download only images
only_videos: false       # Download only videos/GIFs
thumbnails: false        # Download thumbnails instead of full size
verbose: false           # Display detailed text logs instead of progress bar

# Site-specific credentials
# These override global 'api_key' and 'user_id'
rule34_api_key: "..."
rule34_user_id: "..."
gelbooru_api_key: "..."
gelbooru_user_id: "..."

# Global credentials (used if site-specific ones are missing)
api_key: "..."
user_id: "..."

# Target site
site: "rule34"           # Default site to use
```

## Credentials Guide

Some sites (specifically **Rule34** and **Gelbooru**) require an API key and User ID for reliable access.

### Rule34
1. Log in to [rule34.xxx](https://rule34.xxx/index.php?page=account&s=options).
2. or Go to **Account** -> **Options**.
3. Your API key and ID will be displayed there.

### Gelbooru
1. Log in to [gelbooru.com](https://gelbooru.com/index.php?page=account&s=options).
2. or Go to **My Account** -> **Options**.
3. Locate your API Key and User ID.

## Precedence Rules

The scraper resolves configuration in the following order (highest priority first):

1. **Command Line Arguments**: `--amount`, `--site`, etc.
2. **Specified Config File**: Passed via `--config <path>`.
3. **Local Config**: `config.yaml` in the current directory.
4. **Default Values**: Hardcoded defaults in `src/core/config.sh`.
