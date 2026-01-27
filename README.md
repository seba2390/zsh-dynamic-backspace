# zsh-dynamic-backspace

A Zsh plugin that enhances the backspace key with intelligent multi-stage deletion behavior. Instead of just deleting characters one by one, this plugin provides a progressive deletion system that helps you delete words more efficiently with visual feedback.

## ✨ Features

- **Multi-stage deletion**: Normal character deletion → word highlighting → word deletion
- **Configurable threshold**: Control how many characters to delete before highlighting kicks in
- **Visual feedback**: See what you're about to delete with customizable highlight colors
- **Smart context detection**: Automatically resets on whitespace, preventing accidental deletions
- **Customizable word boundaries**: Define which characters should be treated as part of a word (useful for paths, IPs, etc.)

## 🎬 How It Works

The plugin operates in distinct stages based on consecutive backspace presses:

1. **Stage 1-N** (Normal Deletion): Deletes characters one at a time, just like normal backspace
   - Default: First 3 backspace presses (configurable)

2. **Stage N+1** (Highlight): Deletes one more character AND highlights the remaining word
   - Visual feedback shows you exactly what will be deleted next
   - Uses customizable colors to make the selection clear

3. **Stage N+2** (Region Deletion): Deletes the entire highlighted region
   - One final backspace removes the whole highlighted word


## 📦 Installation

### Oh My Zsh

1. Clone this repository into your Oh My Zsh custom plugins directory:
   ```bash
   git clone https://github.com/seba2390/zsh-dynamic-backspace ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-dynamic-backspace
   ```

2. Add the plugin to your `~/.zshrc` file:
   ```bash
   plugins=(
       # ... other plugins
       zsh-dynamic-backspace
   )
   ```

3. Restart your terminal or source your config:
   ```bash
   source ~/.zshrc
   ```

### Manual Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/seba2390/zsh-dynamic-backspace ~/.zsh/zsh-dynamic-backspace
   ```

2. Add to your `~/.zshrc`:
   ```bash
   source ~/.zsh/zsh-dynamic-backspace/zsh-dynamic-backspace.plugin.zsh
   ```

3. Restart your terminal or reload:
   ```bash
   source ~/.zshrc
   ```

## ⚙️ Configuration

All configuration must be set **before** loading the plugin in your `~/.zshrc`.

### Deletion Threshold

Control how many character deletions occur before highlighting activates:

```bash
# Default: 3 (highlight after 3rd character deletion)
export DYNAMIC_BACKSPACE_THRESHOLD=3

# For more aggressive highlighting (2-stage behavior):
export DYNAMIC_BACKSPACE_THRESHOLD=1

# For delayed highlighting (5-stage behavior):
export DYNAMIC_BACKSPACE_THRESHOLD=5
```

**Tip:** Lower values (1-2) make the plugin more aggressive, higher values (4-6) give you more fine-grained control.

### Word Boundary Characters

Define which characters should be treated as part of a word (excluded from word boundaries):

```bash
# Default: Excludes / . and - from word boundaries
# (useful for paths like /usr/local or IPs like 192.168.1.1)
export DYNAMIC_BACKSPACE_WORDCHARS=${WORDCHARS//[\/\.\-]}

# To also include @ and : (useful for emails/URLs):
export DYNAMIC_BACKSPACE_WORDCHARS=${WORDCHARS//[\/\.\-\@\:]}

# To use default Zsh word boundaries (no special treatment):
export DYNAMIC_BACKSPACE_WORDCHARS=$WORDCHARS
```

### Highlight Colors

Customize the appearance of the highlighted region:

```bash
# Background color (default: blue)
export DYNAMIC_BACKSPACE_HIGHLIGHT_BG="blue"

# Foreground/text color (default: green)
export DYNAMIC_BACKSPACE_HIGHLIGHT_FG="green"

# Additional styles (optional)
export DYNAMIC_BACKSPACE_HIGHLIGHT_STYLE="bold"
# Options: bold, underline, standout (reverse video), or combinations
```

**Available colors:**
- Basic: `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`
- 256-color codes: Use `#NNN` format (e.g., `#196` for bright red, `#21` for bright blue)

**Example configurations:**

```bash
# High contrast (red background, white text, bold)
export DYNAMIC_BACKSPACE_HIGHLIGHT_BG="red"
export DYNAMIC_BACKSPACE_HIGHLIGHT_FG="white"
export DYNAMIC_BACKSPACE_HIGHLIGHT_STYLE="bold"

# Subtle (dark gray background, light gray text)
export DYNAMIC_BACKSPACE_HIGHLIGHT_BG="#235"
export DYNAMIC_BACKSPACE_HIGHLIGHT_FG="#250"

# Classic terminal selection (reverse video)
export DYNAMIC_BACKSPACE_HIGHLIGHT_BG="white"
export DYNAMIC_BACKSPACE_HIGHLIGHT_FG="black"
export DYNAMIC_BACKSPACE_HIGHLIGHT_STYLE="standout"
```

### Complete Configuration Example

```bash
# ~/.zshrc

# Configure dynamic backspace before loading the plugin
export DYNAMIC_BACKSPACE_THRESHOLD=2
export DYNAMIC_BACKSPACE_WORDCHARS=${WORDCHARS//[\/\.\-\@]}
export DYNAMIC_BACKSPACE_HIGHLIGHT_BG="red"
export DYNAMIC_BACKSPACE_HIGHLIGHT_FG="white"
export DYNAMIC_BACKSPACE_HIGHLIGHT_STYLE="bold"

# Load Oh My Zsh with the plugin
plugins=(
    git
    zsh-dynamic-backspace
)

source $ZSH/oh-my-zsh.sh
```


## 📝 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page.

## 📧 Author

Created by Sebastian Yde Madsen

---
