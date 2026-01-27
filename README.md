<div align="center">

![Neovim Config Preview](./assets/ui-preview.gif)

# 🚀 My Neovim Configuration

_To be jj cake hand 🍰✋._

[![Neovim](https://img.shields.io/badge/Neovim-0.10+-blueviolet.svg?style=flat-square&logo=Neovim&logoColor=white)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Made%20with%20Lua-2C2D72.svg?style=flat-square&logo=lua&logoColor=white)](https://lua.org)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](./LICENSE)

</div>

---

## ✨ Features

<table>
  <tr>
    <td>
      <h3>🎨 Beautiful UI</h3>
      <ul>
        <li>Catppuccin theme</li>
        <li>Dashboard animations</li>
        <li>Colorful window separators</li>
        <li>Enhanced lualine</li>
      </ul>
    </td>
    <td>
      <img src="./assets/ui-preview.png" alt="UI Preview" />
    </td>
  </tr>
  <tr>
    <td>
      <img src="./assets/editing.png" alt="Editing Experience" />
    </td>
    <td>
      <h3>⚡ Superior Editing Experience</h3>
      <ul>
        <li>Autocompletion with blink.cmp</li>
        <li>Code navigation with Treesitter</li>
        <li>Motions with Flash & Hop</li>
        <li>Text objects & Surround operations</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>
      <h3>🤖 AI-Powered Development</h3>
      <ul>
        <li>AI code suggestions & NES</li>
        <li>AI-assisted refactoring</li>
        <li>AI snippet generation</li>
        <li>AI sidekick integration</li>
      </ul>
    </td>
    <td>
      <img src="./assets/ai-features.png" alt="AI Features" />
    </td>
  </tr>
  <tr>
    <td>
      <img src="./assets/debugging.png" alt="Debugging" />
    </td>
    <td>
      <h3>🔍 Professional Debugging</h3>
      <ul>
        <li>DAP integration with UI</li>
        <li>Python debugging support</li>
        <li>Breakpoints & watch expressions</li>
        <li>Step-through debugging</li>
      </ul>
    </td>
  </tr>
</table>

### 🎯 Additional Highlights

- **🔥 Performance**: Lazy loading with lazy.nvim for instant startup
- **📝 Rich Editing**: Markdown preview, CSV viewer, and Jupyter notebook support
- **🌳 JJ Integrated**: Fully compatible with Jujutsu (jj) and Git version control
- **🔧 LSP & Formatting**: Full LSP support via Mason, plus conform.nvim and nvim-lint
- **🎯 Code Navigation**: Symbols outline, Trouble, Flash, and Hop for seamless movement
- **📦 Session Management**: Automatic session persistence
- **🎨 Syntax Highlighting**: Treesitter with rainbow delimiters & indentation guides
- **🔍 Search & Replace**: Powerful search via snacks.picker & Grug-far
- **🐍 Python Development**: Virtual env selector and REPL integration with vim-slime

---

## 📸 Screenshots

<div align="center">
  <figure>
    <img src="./assets/screenshot-1.png" width="100%" alt="AI Suggestions" />
    <figcaption>Copilot AI Intelligent Completion & Next Edit Suggestions</figcaption>
  </figure>

  <hr>

  <figure>
    <img src="./assets/screenshot-2.png" width="100%" alt="File Picker" />
    <figcaption>Snacks Picker Fuzzy File Search</figcaption>
  </figure>

  <hr>

  <figure>
    <img src="./assets/screenshot-5.png" width="100%" alt="JJ Integration" />
    <figcaption>Jujutsu Version Control System Integration</figcaption>
  </figure>

  <hr>

  <figure>
    <img src="./assets/screenshot-3.png" width="100%" alt="Diff Viewer" />
    <figcaption>Visual Diff Viewer</figcaption>
  </figure>

  <hr>

  <figure>
    <img src="./assets/screenshot-4.png" width="100%" alt="Jupyter Notebook" />
    <figcaption>Jupyter Notebook Integration (Bugs)</figcaption>
  </figure>
</div>

---

## 💡 Usage & Inspiration

> **⚠️ Important**: This is **NOT** a Neovim distribution.
> It's my personal configuration that uses many plugins and custom settings.
> I'm sharing it to inspire others to build their own Neovim setup.
> Hope it helps!

### If You Want to Try It

If you want to test this configuration:

```bash
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

# Clone this configuration
jj git clone https://github.com/RicardoRyn/nvim.git ~/.config/nvim

# Start Neovim
nvim
```

After the first launch:

1. **Check plugins** with `:Lazy` to ensure all plugins are installed correctly
2. **Check health** with `:checkhealth` to verify system dependencies and LSP configuration
3. **Customize it** for your own needs!

---

## 🗂️ Project Structure

```
~/.config/nvim/ ├── init.lua                # Entry point
├── lazy-lock.json          # Plugin version lock file
├── stylua.toml             # Lua formatter config
├── .luarc.json             # Lua language server config
│
├── lua/
│   ├── config/             # Core configuration
│   │   ├── autocmds.lua    # Auto commands
│   │   ├── keymaps.lua     # Key mappings
│   │   ├── lazy.lua        # Lazy.nvim loader
│   │   ├── lsp.lua         # LSP configuration
│   │   └── options.lua     # Neovim options
│   │
│   ├── plugins/            # Plugin specifications
│   │   ├── ai/             # AI-related plugins
│   │   ├── core/           # Core plugins (blink, conform, mason, etc.)
│   │   ├── dap/            # Debug adapter protocol
│   │   ├── disabled/       # Disabled plugin configs
│   │   ├── editor/         # Editor enhancements
│   │   ├── tools/          # Development tools
│   │   ├── ui/             # UI plugins
│   │   └── vcs/            # Version control (git, jj)
│   │
│   ├── neogen/             # Neogen annotation templates
│   │
│   └── utils/              # Utility modules
│
├── after/                  # After plugins loaded
├── lsp/                    # LSP server custom configs
├── snippets/               # Custom snippets
└── assets/                 # Screenshots & images
```

---

## ⌨️ Keymaps

### Leader Keymaps

```
<leader>
├── <Space> (Smart Files)
├── a (AI)
│   ├── a - Sidekick toggle CLI
│   ├── c - Sidekick toggle Copilot
│   ├── d - Detach CLI session
│   ├── f - Send file
│   ├── i - Sidekick toggle iFlow
│   ├── p - Sidekick select prompt (including Visual mode)
│   ├── s - Select CLI
│   ├── t - Send this (including Visual mode)
│   └── v - Send visual selection (including Visual mode)
├── b (Buffer)
│   ├── a - Delete all buffers
│   ├── b - Delete pick buffer
│   ├── d - Delete buffer
│   ├── l - Delete buffers to the left
│   ├── o - Delete other buffers
│   ├── p - Toggle pin
│   ├── r - Delete buffers to the right
│   ├── < - Move buffer left
│   └── > - Move buffer right
├── c (Copy/CSV)
│   ├── c - Copy absolute path (in Mini Files)
│   ├── d - Copy directory path (in Mini Files)
│   ├── f - Copy file name (in Mini Files)
│   ├── r - Copy relative path (in Mini Files)
│   └── sv - Toggle CSV view
├── d (Debug)
│   ├── b - Breakpoint
│   ├── B - Conditional Breakpoint
│   ├── c - Run to Cursor
│   ├── C - Clear Breakpoints
│   ├── d - Disconnect
│   ├── D - Disconnect (Terminate Debuggee)
│   ├── h - Hover
│   ├── i - Step into
│   ├── k - Step back
│   ├── o - Step over
│   ├── O - Step out
│   ├── q - Terminate session
│   ├── r - Restart
│   ├── R - Toggle REPL
│   ├── s - Start/Continue
│   ├── u - Toggle UI
│   └── f (Float)
│       ├── e - Float Expression
│       ├── f - Float Frames
│       ├── s - Float Scopes
│       ├── S - Float Sessions
│       └── t - Float Threads
├── e (Explorer)
│   ├── e - Mini files
│   ├── f - Mini files (current file)
│   └── s - File explorer (for Picture preview)
├── f (Find)
│   ├── c - Find config files
│   ├── f - Find files
│   ├── g - Find git files
│   ├── p - Projects
│   ├── r - Recent files
│   ├── t - Todo (buffers)
│   └── T - Todo/Fix (buffers)
├── g (Git)
│   ├── b - Blame line
│   ├── B - Blame buffer
│   ├── p - Preview hunk inline
│   ├── P - Preview hunk (float)
│   ├── r - Reset hunk
│   ├── R - Reset buffer
│   ├── t - Toggle current line blame
│   ├── w - Toggle word diff
│   ├── g - LazyGit
│   └── h (Github)
│       ├── i - GitHub Issues (open)
│       ├── I - GitHub Issues (all)
│       ├── p - GitHub Pull Requests (open)
│       └── P - GitHub Pull Requests (all)
├── h (Home)
├── j (Jujutsu)
│   ├── a - JJ annotate file
│   ├── b (bookmark)
│   │   ├── c - JJ bookmark create
│   │   ├── d - JJ bookmark delete
│   │   └── m - JJ bookmark move
│   ├── A - JJ abandon
│   ├── C - Conflitc
│   ├── d - JJ diff current buffer
│   ├── D - JJ describe
│   ├── e - JJ edit
│   ├── f - JJ fetch
│   ├── l - JJ log (all)
│   ├── L - JJ log
│   ├── n - JJ new
│   ├── r - JJ rebase
│   ├── R - JJ redo
│   ├── s - JJ status
│   ├── S - JJ squash
│   ├── U - JJ undo
│   ├── p - JJ push
│   └── t - JJ tug
├── k (Kernel) (only in jupyter notebook)
├── l (LSP)
│   ├── a - Code Actions
│   ├── d - Show Diagnostics (line)
│   ├── D - Show Diagnostics (buffer)
│   ├── f - Code Format
│   ├── m - Toggle Code Block
│   ├── n - Generate docstring
│   ├── r - Rename Symbol
│   ├── v - Virtual Env selector
│   └── sp - Restart LSP
├── L (Lazy)
├── n (Noice)
│   ├── a - All
│   ├── e - Error
│   ├── h - History
│   ├── l - Last Message
│   ├── m - Messages
│   └── n - Noice Picker
├── o (Outline)
├── p (Paste)
├── s (Search/System)
│   ├── b - Buffers
│   ├── c - Commands
│   ├── d - Diagnostics (buffer)
│   ├── D - Diagnostics
│   ├── h - Help pages
│   ├── i - Icons
│   ├── I - Incoming calls
│   ├── j - JJ picker status
│   ├── J - Jumps
│   ├── k - Keymaps
│   ├── l - Search for plugin spec
│   ├── L - LSP info
│   ├── m - Marks
│   ├── O - Outgoing calls
│   ├── p - Spelling
│   ├── P - Pickers
│   ├── r - Resume
│   ├── R - Search and replace (Grug-far)
│   ├── s - LSP symbols (buffer)
│   ├── S - LSP symbols (workspace)
│   ├── t - Todo comments
│   ├── T - Todo/Fix comments
│   ├── u - Undotree
│   ├── v - Clipboard history
│   ├── " - Registers
│   ├── . - Scratch select
│   └── / - Search history
├── S (Session)
│   ├── d - Don't save current session
│   ├── l - Restore last session
│   ├── s - Restore session
│   └── S - Select session
├── t (Tab/Toggle)
│   ├── d - Close tab
│   ├── n - New tab
│   └── s - Tab split
├── u (UI Toggle)
│   ├── b - Toggle dark background
│   ├── c - Colorschemes
│   ├── d - Toggle diagnostics
│   ├── D - Toggle dim
│   ├── g - Toggle git signs
│   ├── h - Toggle inlay hints
│   ├── l - Toggle relative number
│   ├── L - Toggle line number
│   ├── n - Noice dismiss
│   ├── r - Redraw / clear hlsearch / Diff update
│   ├── w - Toggle wrap
│   ├── z - Toggle zoom
│   └── Z - Toggle zen mode
├── x (Trouble/QuickFix)
│   ├── l - LSP definitions/references (Trouble)
│   ├── L - Location list (Trouble)
│   ├── Q - Quickfix list (Trouble)
│   ├── s - Symbols (Trouble)
│   ├── x - Diagnostics (Trouble)
│   └── X - Buffer diagnostics (Trouble)
├── z (Zoxide)
├── . - Scratch
├── : - Command History
├── ? - Buffer Local Keymaps
└── / (Grep)
    ├── b - Grep buffers
    ├── l - Lines
    ├── w - Grep word
    └── / - Grep
```

### Other Keymaps

**Motion & Navigation**

- `jk` - Exit insert mode
- `s` / `S` / `r` / `R` - Flash jump/treesitter/search
- `xw` / `xr` - Flash words/resume
- `xj` / `xk` / `xl` / `xh` - Hop navigation

**LSP**

- `gd` / `gD` / `gr` / `gI` / `gy` - Goto definition/declaration/references/implementation/type

**Git**

- `]g`/ `gh` / `[g` / `gH` - Next/previous git hunk

**Buffer**

- `<S-h>` / `<S-l>` - Previous/next buffer

**Windows**

- `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` - Navigate tmux windows

**Yank/Paste**

- `y` / `p` / `P` / `gp` / `gP` - Yank/Paste operations
- `[y` / `]y` - Cycle yank history
- `gsa` / `gsd` / `gsr` - Surround add/delete/replace

**Copilot**

- `<Tab>` - Goto/Apply next edit suggestion
- `<C-y>` / `<C-w>` - Accept Copilot suggestion/word
- `<M-]>` / `<M-[>` - Next/previous Copilot suggestion
- `<C-]>` - Dismiss Copilot suggestion

**Terminal**

- `<C-/>` / `<C-_>` - Open terminal

---

<div align="center">

**⭐ If you find this config helpful, please give it a star! ⭐**

**💬 Feel free to open an [issue](https://github.com/RicardoRyn/nvim/issues) or submit a [PR](https://github.com/RicardoRyn/nvim/pulls) if you have any ideas or suggestions! 💬**

</div>
