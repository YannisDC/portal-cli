# portal-cli

A CLI tool to set up portal projects for SDK translation. This tool creates a structured project directory with the upstream repository and a target language port directory.

## Installation

### Using Homebrew

#### Option 1: Local Installation (For Testing)
For local development and testing, use the install script:
```bash
./install-local.sh
```

This will copy the script to Homebrew's bin directory.

#### Option 2: Install via Homebrew Tap
1. The tap has been created at: `yannisdecl/portal`
2. For local testing with the tap:
   ```bash
   # Create a tarball first
   cd /Users/yannisdecl/code/portal
   tar czf portal-cli.tar.gz portal-cli
   
   # Update the sha256 in the formula, then:
   brew install yannisdecl/portal/portal-cli
   ```

3. For production (once on GitHub):
   - Create a GitHub repository for your tap (e.g., `homebrew-portal`)
   - Add the `portal-cli.rb` formula to `Formula/portal-cli.rb` in that repository
   - Update the formula with the GitHub URL
   - Install via tap:
     ```bash
     brew tap yourusername/portal
     brew install portal-cli
     ```

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

```bash
portal open --upstream <repo-url> --lang <language> [--version <version>] [--name <custom-name>]
```

### Arguments

- `--upstream`: The upstream repository URL or path (e.g., `github.com/user/repo`, `https://github.com/user/repo.git`)
- `--lang`: The target language for the port (e.g., `python`, `rust`, `swift`, `go`)
- `--version`: (Optional) Specific version/tag/branch to checkout
- `--name`: (Optional) Custom name for the project directory. Defaults to `portal-{repo-name}`

### Examples

```bash
# Create a portal project for a Swift port
portal open --upstream github.com/YannisDC/upstream-example --version 0.5.0 --lang swift

# Create a portal project for a Python port
portal open --upstream github.com/user/sdk-repo --lang python

# Create a portal project with a custom name
portal open --upstream https://github.com/user/sdk-repo.git --lang rust --name my-custom-portal

# Using full GitHub URL
portal open --upstream https://github.com/user/sdk-repo.git --lang swift --version 0.5.0
```

## Project Structure

After running `portal-cli`, you'll get a directory structure like this:

```
portal-{repo-name}/
├── upstream/          # The cloned upstream repository
└── {target-language}-port/  # Directory for translated files
    └── README.md
```

## Requirements

- Python 3.6+
- Git (for cloning repositories)

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

