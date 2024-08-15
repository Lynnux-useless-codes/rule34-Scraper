# rule34-Scraper

A flexible script for downloading images from the Rule34 API. The script supports configuration via command-line arguments or a YAML configuration file and provides options for specifying tags, download limits, and more.

- [rule34-downloader](#rule34-downloader)
  - [Features](#features)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Command-Line Arguments](#command-line-arguments)
    - [Examples](#examples)
  - [Configuration File](#configuration-file)
    - [Example config.yaml:](#example-configyaml)
  - [Options](#options)
  - [Troubleshooting](#troubleshooting)
  - [Contribution](#contribution)
  - [License](#license)

## Features

- Flexible Tagging: Download images based on specified tags.
- Configurable Limits: Set limits on the number of images or pages to download.
- Multithreading: Download multiple images simultaneously with configurable thread limits.
- Configurable: Use a YAML configuration file for settings or specify them via command-line arguments.

## Requirements

- **bash**: Required for running the script
- **cURL**: Used for making HTTP requests.
- **jq**: A command-line JSON processor to parse and handle API responses.

## Installation

1. Clone the repository:

```bash
git clone https://github.com/Lynnux-useless-codes/rule34-Scraper.git
cd rule34-Scraper
```

2. Ensure you have `curl` and `jq` installed on your system:

```bash
# For Debian/Ubuntu
sudo apt install curl jq

# Arch Linux
sudo pacman -S curl jq

# Other Linux Distributions
sudo dnf install curl jq

# For macOS (with Homebrew)
brew install curl jq
```

3. Make the script executable:

```bash
chmod +x downlaoder.sh
```

## Usage

You can run the downloader either by specifying command-line arguments or using a configuration file.

### Command-Line Arguments

- `tags` (Required): The tags to search for. Enclose in quotes if it contains spaces.
- `--amount` (Optional): The total number of images to download.
- `--pages` (Optional): The number of pages to fetch.
- `--config` (Optional): Path to a YAML configuration file.

### Examples

1. Download images with specific tags and limit by amount:

```bash
./downlaoder.sh "anime girl" --amount 25
```

2. Download images using a configuration file:

```bash
./downlaoder.sh --config config.yaml
```

## Configuration File

You can specify a YAML configuration file with the following options:

- `tags`: Tags for the search (e.g., "anime girl").
- `max_threads`: Maximum number of simultaneous downloads (default is 5).
- `image_folder`: Directory to save the images (./default is downloaded).
- `amount`: Total number of images to download (if not using --pages).

### Example config.yaml:

```yaml
tags: "anime girl"
max_threads: 10
image_folder: "downloads"
amount: 25
```

Note: If both `--amount` and `--pages` are specified, `--amount` takes precedence.

## Options

- `--amount`: Total number of images to download.
- `--pages`: Number of pages to fetch.
- `--config`: Path to YAML configuration file.

## Troubleshooting

- **Empty Response**: If you encounter empty responses, ensure the tags are correctly specified and try different tags or limits.
- **Invalid Config File**: Verify that the YAML configuration file is correctly formatted and paths are valid.

## Contribution

Contributions are welcome! Please open an issue or submit a pull request for any features or bug fixes.

## License

This project is licensed under the [MIT License](/LICENSE).
