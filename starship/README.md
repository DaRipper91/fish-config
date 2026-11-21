# Starship Prompt Presets

Curated prompt themes for the [Starship](https://starship.rs/) cross-shell prompt, managed and styled via [Starship-Command](file:///home/daripper/Projects/Starship-Command).

## Presets Included

- **`starship.cyber_phoenix.toml`**: Active host prompt theme. Features Nordic Elder Futhark rune OS marker (`ᛞ`), powerline segment separators, vibrant cyberpunk gradients (`solar_flare`, `cyber_cyan`, `phoenix_pink`, `arcane_purple`), git status, and runtime indicators.
- **`starship.showcase.toml`**: Minimal high-contrast demo theme from Starship-Command.

## Usage

To apply a preset theme:

```fish
# Back up current configuration
cp ~/.config/starship.toml ~/.config/starship.toml.bak

# Apply cyber_phoenix preset
cp starship.cyber_phoenix.toml ~/.config/starship.toml
```

To visually edit or tweak palettes with live ANSI preview:

```fish
starship-command
```
