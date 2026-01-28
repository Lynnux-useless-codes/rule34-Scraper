# TODO (Issue-Driven, Actionable)

This list is derived **only from reported issues and comments**. Each item is written to be concrete and testable.

---

## 1. CLI Tag Parsing (Primary Confusion Source)

* [ ] **Make tag handling explicit in code comments & help output**

  * Define: `TAG = first argument that does not start with --`
  * Enforce this consistently (error if multiple bare args are provided)

* [ ] **Improve error when no tag is provided**

  * Replace `tags required` with:

    * What is missing
    * One valid example command

* [ ] **Document multi-tag usage via `+` separator**

  * Explicitly state this mirrors Booru API behavior
  * Example shown in README and `--help`

* [ ] **Reject unsupported `--tags` flag explicitly**

  * If user passes `--tags`, show a helpful error instead of failing silently

---

## 2. Config File Handling (Reported as Broken)

* [ ] **Reproduce config-only usage path**

  * Run script with:

    ```bash
    ./downloader.sh --config ./config.yaml
    ```
  * Ensure API keys, tags, and site load without prompting

* [ ] **Add validation for required config keys**

  * `site`, `tags`, and auth fields where applicable
  * Fail fast with a clear message if missing

* [ ] **Clarify config vs CLI precedence**

  * Decide and enforce:

    * CLI overrides config
    * Config provides defaults

* [ ] **Auto-load config.yaml if present in repo root**

  * Only if `--config` is not explicitly provided

---

## 3. Amount / Limit Semantics

* [ ] **Define and enforce `amount = 0` behavior**

  * Explicitly mean: unlimited / all matching posts
  * Prevent fallback guessing

* [ ] **Fix edge case: `--amount 1` causing "site disabled"**

  * Add unit-style test case or reproducible script snippet
  * Guard against zero/one-page logic errors

---

## 4. Progress Feedback (Requested Improvement)

* [ ] **Add batch-level progress output**

  * Format: `Downloaded X / Y images`
  * Update after each successful download

* [ ] **Optional per-file status line**

  * Only when verbose mode is enabled (if added)

---

## 5. Preview / Dry-Run Mode

* [ ] **Add `--dry-run` or `--preview` flag**

  * Perform API query only
  * Output total post count and resolved URL
  * Exit without downloading

---

## 6. README / Documentation Fixes (Directly From Issues)

* [ ] **Add a "How tags work" section**

  * Single tag vs multi-tag (`+`)
  * Negative tags (`-guro`)

* [ ] **Add "Common mistakes" section**

  * Using `--tags`
  * Forgetting to pass a tag
  * Expecting config auto-load

* [ ] **Document filename choice explicitly**

  * Explain why post ID is used (API limitation)

---

## 7. Non-Goals (Make Explicit)

* [ ] **Document intentional non
