# 📖 Usage Guide

This guide provides detailed examples and advanced usage tips for the Booru-Scraper.

## Basic CLI Usage

The most common way to run the scraper is by providing tags directly:

```bash
./downloader.sh "high_res+solo"
```

### Specifying Amount

Control the total number of files to download:

```bash
./downloader.sh --amount 50 "high_res"
```

### Specifying Pages

Download a specific number of pages (useful if you want a lot of variety):

```bash
./downloader.sh --pages 5 "solo"
```

## "Download All" Mode

To download every single post matching your tags, use any of the following:
- `--amount 0`
- `--amount -1`
- `--amount "*"`

The scraper will automatically estimate the total count and start an asynchronous pipelined download until the API returns no more results.

## Filtering Media

You can filter results by media type:

### Only Images

Downloads `.jpg`, `.jpeg`, `.png`, and `.gif`:

```bash
./downloader.sh --only-images "oc"
```

### Only Videos

Downloads `.mp4`, `.webm`, and `.gif`:

```bash
./downloader.sh --only-videos "animated"
```

## Performance & Management

### Concurrency

Adjust the number of simultaneous downloads (default is 5):

```bash
./downloader.sh --threads 10 "big_ass"
```

### Target Folder

Specify where files should be saved:

```bash
./downloader.sh --folder "my_collection" "tags"
```

### SHA-256 Caching

Enable caching to skip files you've already downloaded. The scraper will maintain a `cache_hashes.txt` file:

```bash
./downloader.sh --cache-hash "tags"
```

## Site Selection

The default site is **Rule34**. You can switch sites using `--site`:

| Site | Value |
| --- | --- |
| Rule34 (Default) | `rule34` |
| Gelbooru | `gelbooru` |
| Safebooru | `safebooru` |
| HypnoHub | `hypnohub` |
| Konachan | `konachan` |
| Realbooru | `realbooru` |
| XBooru | `xbooru` |

Example:

```bash
./downloader.sh --site gelbooru --amount 5 "tags"
```

> [!TIP]
> Some sites allow you to ignore certain tags by adding `-` infront of a tag.
>
> For example: `--tags "high_res solo -animated"` will download all content with the tags `high_res` and `solo`, that do not include the tag `animated`.