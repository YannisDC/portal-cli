# portal-cli

A CLI tool for porting code repositories to different programming languages. It helps you translate and maintain codebases across languages (Python, Rust, Swift, Go, etc.) by creating a structured project that keeps the original source code alongside your translated port, tracks version changes, and monitors upstream updates.

## Installation

### Using Homebrew

Install `portal-cli` using the Homebrew tap:

```bash
# Tap the repository and install
brew tap yannisdecl/portal
brew install portal-cli
```

**If you're prompted for a GitHub username/password**, use the explicit HTTPS URL:

```bash
brew tap yannisdecl/portal https://github.com/YannisDC/homebrew-portal.git
brew install portal-cli
```

**Optional:** Create a symlink for convenience:
```bash
ln -sf /opt/homebrew/bin/portal-cli /opt/homebrew/bin/portal
```

**Install PyYAML** for config-based commands (required for `--port`, `list`, `tags`, `version`):
```bash
# On modern macOS with externally-managed Python, use:
pip3 install --break-system-packages pyyaml
# Or use --user flag:
pip3 install --user pyyaml
```

**For Maintainers:** To update the formula after creating a new release:

```bash
# 1. Create new tarball
rm -f portal-cli.tar.gz
tar czf portal-cli.tar.gz portal-cli

# 2. Calculate SHA256 and update formula
SHA256=$(shasum -a 256 portal-cli.tar.gz | awk '{print $1}')
sed -i '' "s/sha256 \".*\"/sha256 \"$SHA256\"/" /opt/homebrew/Library/Taps/yannisdecl/homebrew-portal/Formula/portal-cli.rb

# 3. Update the version and URL in the formula, then commit and push to GitHub
# 4. Users can update with: brew upgrade portal-cli
```

**Note:** For config-based commands (`--port`, `list`, `tags`, `version`), you need to install PyYAML separately:
```bash
# For externally-managed Python environments (modern macOS):
pip3 install --break-system-packages pyyaml

# Or with --user flag:
pip3 install --user pyyaml
```

Direct mode (using `--upstream` and `--lang`) works without PyYAML.

### Manual Installation

1. Make the script executable:
   ```bash
   chmod +x portal-cli
   ```

2. Move it to a directory in your PATH:
   ```bash
   sudo mv portal-cli /usr/local/bin/
   ```
   
   Or create a symlink:
   ```bash
   sudo ln -s $(pwd)/portal-cli /usr/local/bin/portal-cli
   ```

## Usage

### Direct Mode (Creates New Portal Project)

```bash
portal open --upstream <repo-url> --lang <language> [--version <version>] [--name <custom-name>]
```

**Arguments:**
- `--upstream`: The upstream repository URL or path (e.g., `github.com/user/repo`, `https://github.com/user/repo.git`). Required for new projects.
- `--lang`: The target language for the port (e.g., `python`, `rust`, `swift`, `go`). Can be used alone if portal.yaml exists.
- `--version`: (Optional) Specific version/tag/branch to checkout
- `--name`: (Optional) Custom name for the project directory. Defaults to `portal-{repo-name}`

**Examples:**
```bash
# Create a portal project for a Swift port
portal open --upstream github.com/YannisDC/upstream-example --version 0.5.0 --lang swift

# Create a portal project for a Python port
portal open --upstream github.com/user/sdk-repo --lang python

# Create a portal project with a custom name
portal open --upstream https://github.com/user/sdk-repo.git --lang rust --name my-custom-portal

# Add a new port to existing upstream (if portal.yaml exists)
portal open --lang dart  # Uses the existing upstream from portal.yaml
```

### Config-Based Mode (Uses portal.yaml)

After creating a portal project, a `portal.yaml` configuration file is created. You can edit this file to define multiple upstreams and ports, then use these commands:

**1. Open a portal (initial port from a version tag):**
```bash
portal open --port <port-name> --version <version>
```

**2. Update version manually (for testing):**
```bash
portal version --port <port-name> --version <version>
```

**3. List opened portals:**
```bash
portal list
```

**4. List available version tags:**
```bash
portal tags  # Auto-detects upstream if only one exists
portal tags --upstream <upstream-name>  # Specify upstream if multiple exist
```

**5. Watch for upstream changes:**
```bash
portal watch  # Auto-detects upstream if only one exists
portal watch --upstream <upstream-name>  # Specify upstream if multiple exist
portal watch --upstream <upstream-name> --interval 1800  # Check every 30 minutes
portal watch --upstream <upstream-name> --once  # Check once and exit
portal watch --upstream <upstream-name> --detailed  # Show detailed file diffs
```

**Example workflow:**
```bash
# 1. Create initial portal project
portal open --upstream github.com/user/sdk-repo --lang python

# 2. Edit portal.yaml to add more ports/upstreams
# 3. Open a specific port from config
portal open --port python-sdk --version 0.5.0

# 4. List all configured ports
portal list

# 5. See available tags
portal tags --upstream upstream-foo

# 6. Update to a new version
portal version --port python-sdk --version 0.6.0

# 7. Watch for new upstream releases
portal watch --upstream upstream-foo
# This will monitor for new tags and show you what changed
# When a new release is detected, it shows:
#   - Summary of changes (files added/modified/deleted)
#   - List of changed files
#   - Saves full diff to: diffs/diff-{upstream}-{from}-to-{to}.patch
#   - Optionally detailed diffs for important files
```

## Project Structure

After running `portal open`, you'll get a directory structure like this:

```
portal-{repo-name}/
├── .cursorrules       # AI assistant rules for port maintenance
├── portal.yaml        # Configuration file for upstreams and ports
├── upstream/          # The cloned upstream repository
├── diffs/             # Diff files saved by portal watch
│   └── diff-{upstream}-{from}-to-{to}.patch
└── {target-language}-port/  # Directory for translated files
    └── README.md
```

### portal.yaml Configuration

The `portal.yaml` file defines your upstreams and ports:

```yaml
upstreams:
  - name: upstream-foo
    repo: github.com/owner/foo
    branch: main
    # Optional: subdirectory to monitor
    # path: packages/core

ports:
  - name: flutter-port
    repo: github.com/owner/flutter-port
    path: ./packages/sdk
    lang: flutter
    origin: upstream-foo  # Port originates from this upstream
  - name: python-port
    repo: github.com/owner/python-port
    path: ./packages/python-port
    lang: python
    origin: upstream-foo
```

## Requirements

- Python 3.6+
- Git (for cloning repositories)
- PyYAML (for config-based commands): `pip install pyyaml`
  - Note: Direct mode (using `--upstream` and `--lang`) works without PyYAML
  - Config-based commands (`--port`, `list`, `tags`, `version`) require PyYAML

## Development

### Testing Locally

#### Quick Test (Help Command)
```bash
./portal-cli open --help
# or after installation:
portal open --help
```

#### Automated Test Script
Run the included test script:
```bash
./test-portal-cli.sh
```

This will:
- Test the help command
- Create a test portal project with a small public repository
- Verify the directory structure
- Clean up test files

#### Manual Testing

1. **Test with a small public repository:**
   ```bash
   portal open --upstream github.com/octocat/Hello-World --lang python
   ```

2. **Verify the structure:**
   ```bash
   ls -la portal-Hello-World/
   # Should show: upstream/ and python-port/
   
   ls -la portal-Hello-World/upstream/
   # Should show the cloned repository files
   
   ls -la portal-Hello-World/python-port/
   # Should show README.md
   ```

3. **Test with version and custom name:**
   ```bash
   portal open --upstream github.com/octocat/Hello-World --lang rust --version main --name my-test-portal
   ls -la my-test-portal/
   ```

4. **Clean up test directories:**
   ```bash
   rm -rf portal-* my-test-portal
   ```

#### Test Different Scenarios

- **Different repository formats:**
  ```bash
  # Short format (github.com/user/repo)
  portal open --upstream github.com/user/repo --lang python
  
  # Full HTTPS URL
  portal open --upstream https://github.com/user/repo.git --lang swift
  
  # With version
  portal open --upstream github.com/user/repo --lang python --version v1.0.0
  ```

- **Different languages:**
  ```bash
  portal open --upstream github.com/user/repo --lang python
  portal open --upstream github.com/user/repo --lang rust
  portal open --upstream github.com/user/repo --lang swift
  portal open --upstream github.com/user/repo --lang go
  ```

## License

[Add your license here]

