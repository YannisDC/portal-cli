# portal-cli

> Port code repositories to different programming languages with ease. Keep original source alongside your translation, track versions, and monitor upstream updates automatically.

[![License: AGPL-3.0](https://img.shields.io/badge/License-AGPL--3.0-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

## Quick Start

```bash
# Install
brew tap yannisdecl/portal
brew install portal-cli

# Create your first port
portal open --upstream github.com/user/sdk-repo --lang python
```

That's it! You now have a structured project with the original source and your port directory.

**Next step:** Use your LLM-enabled IDE (like Cursor, GitHub Copilot, etc.) or CLI tool to translate the code from `upstream/` to your port directory.

## How It Works

`portal-cli` handles the **scaffolding and change tracking**—not the actual code conversion:

1. **Scaffolding**: Creates the project structure with upstream source and port directories
2. **Change Tracking**: Monitors upstream releases and shows what changed
3. **You Convert**: Use your LLM tool (Cursor, Copilot, etc.) to translate the code

This separation lets you use your preferred AI tools while `portal-cli` keeps everything organized and tracks upstream updates.

## Features

- 🚀 **Quick Scaffolding** - Set up port project structure in seconds
- 🔄 **Version Tracking** - Monitor upstream changes automatically
- 📦 **Multi-Language Support** - Python, Rust, Swift, Go, Dart, and more
- 📊 **Change Detection** - Get notified when upstream releases new versions
- ⚙️ **Config-Based** - Manage multiple ports and upstreams with `portal.yaml`
- 🤖 **LLM-Agnostic** - Works with any LLM tool (Cursor, Copilot, Claude, etc.)

## Installation

```bash
brew tap yannisdecl/portal
brew install portal-cli
```

**If prompted for GitHub credentials**, use the explicit URL:
```bash
brew tap yannisdecl/portal https://github.com/YannisDC/homebrew-portal.git
brew install portal-cli
```

**Optional:** Create a shorter alias:
```bash
ln -sf /opt/homebrew/bin/portal-cli /opt/homebrew/bin/portal
```

**Note:** For advanced features (`list`, `tags`, `watch`), install PyYAML:
```bash
pip3 install --break-system-packages pyyaml  # or: pip3 install --user pyyaml
```

## Usage

### Basic: Create a Port

```bash
portal open --upstream github.com/user/repo --lang python
```

This creates:
```
portal-repo/
├── upstream/          # Original source code
├── python-port/       # Your translation (use your LLM tool here)
└── portal.yaml        # Configuration
```

**Then:** Open the project in your LLM-enabled IDE and translate files from `upstream/` to `python-port/` using your AI assistant.

### Advanced: Multiple Ports & Version Management

After creating a project, edit `portal.yaml` to define multiple ports:

```yaml
upstreams:
  - name: my-sdk
    repo: github.com/user/sdk
    branch: main

ports:
  - name: python-port
    lang: python
    origin: my-sdk
  - name: rust-port
    lang: rust
    origin: my-sdk
```

Then use config-based commands:

```bash
portal open --port python-port --version 0.5.0  # Open specific version
portal list                                    # List all ports
portal tags --upstream my-sdk                  # See available versions
portal watch --upstream my-sdk                 # Monitor for updates
```

### Watch for Updates

Automatically monitor upstream for new releases:

```bash
portal watch --upstream my-sdk
# Detects new tags, shows changes, saves diffs
```

## Project Structure

```
portal-{repo-name}/
├── .cursorrules       # AI assistant rules
├── portal.yaml        # Configuration
├── upstream/          # Original repository
├── diffs/             # Saved change diffs
└── {lang}-port/       # Your translation
```

## Requirements

- Python 3.6+
- Git
- PyYAML (for advanced features): `pip install pyyaml`

## Examples

**Try it out with a real example:**
```bash
portal open --upstream github.com/YannisDC/upstream-example --version 0.5.0 --lang swift
```

**More examples:**
```bash
# Port to Python
portal open --upstream github.com/user/sdk --lang python

# Port to Rust with specific version
portal open --upstream github.com/user/sdk --lang rust --version v1.0.0

# Port to Swift with custom name
portal open --upstream github.com/user/sdk --lang swift --name my-swift-sdk
```

## License

AGPL-3.0 - See [LICENSE](LICENSE) for details.
