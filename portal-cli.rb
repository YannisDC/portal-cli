# Homebrew formula for portal-cli
# To install: brew install --build-from-source portal-cli.rb
# Or create a tap: brew tap yourusername/portal && brew install portal-cli
class PortalCli < Formula
  desc "CLI tool to set up portal projects for SDK translation"
  homepage "https://github.com/yourusername/portal"
  url "https://github.com/yourusername/portal/archive/refs/heads/main.zip"
  version "0.1.0"
  sha256 "" # Update this after creating a release: shasum -a 256 <archive>
  
  depends_on "python@3"

  def install
    bin.install "portal-cli"
    chmod 0755, bin/"portal-cli"
  end

  test do
    assert_match "usage: portal-cli", shell_output("#{bin}/portal-cli --help")
  end
end

