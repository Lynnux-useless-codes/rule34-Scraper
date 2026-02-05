# 🛠️ Extending Site Drivers

Booru-Scraper is designed to be easily extendable. You can add support for almost any Booru-style imageboard by creating a new site driver in `src/sites/`.

## Driver Anatomy

A site driver is a simple Bash script that sets a few variables and defines a few functions.

```bash
# Example: src/sites/mysite.sh

# 1. Define the base URL
SITE_BASE_URL="https://mysite.com/index.php"

# 2. (Optional) Check for credentials
if [[ -z "$RULE34_API_KEY" ]]; then
   # You can set SITE_DISABLED=true if the site requires keys
   # or just log a warning.
fi

# 3. Define the URL generator
get_api_url() {
  local limit="$1"  # Number of posts to fetch
  local pid="$2"    # Page ID (usually 0-indexed)
  local tags="$3"   # URL-encoded tags
  
  # Return the full API string (usually XML or JSON)
  echo "${SITE_BASE_URL}?page=dapi&s=post&q=index&limit=${limit}&pid=${pid}&tags=${tags}&json=1"
}

# 4. (Optional) Customize post extraction
# By default, the engine expects a JSON array.
# If the API returns a nested object (like Gelbooru), override this:
extract_posts() {
  local response="$1"
  echo "$response" | jq -c '.post[]'
}
```

## Adding Your Driver

1. Create the `.sh` file in `src/sites/`.
2. The filename (without `.sh`) becomes the value for the `--site` flag.
3. If the site uses standard Booru-style parameters (`pid`, `limit`, `tags`), it should work immediately!

## Guidelines

- **Statelessness**: Drivers should not store state; they only provide URLs and extraction logic.
- **JSON Preferred**: Try to use `&json=1` in your API URLs to simplify parsing.
- **Defaults**: If the site doesn't support a feature (like total count), the engine will automatically handle graceful fallbacks.
