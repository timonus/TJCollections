# TJCollections

Some handy collection classes I've used in a few side projects.

- **`TJCache`** behaves like `NSCache` but has the powers of a strong-to-weak `NSMapTable` and is enumerable.
- **`TJReusePool`** allows you to push and pop objects intended for reuse but it's "lossy" like an `NSCache` (in fact it uses `NSCache` for storage internally).