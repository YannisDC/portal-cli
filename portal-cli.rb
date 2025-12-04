# Homebrew formula for portal-cli
# To install: brew install --build-from-source portal-cli.rb
# Or create a tap: brew tap yourusername/portal && brew install portal-cli
class PortalCli < Formula
  desc "CLI tool to set up portal projects for SDK translation"
  homepage "https://github.com/YannisDC/portal-cli"
  url "https://github.com/YannisDC/portal-cli/archive/refs/tags/0.1.0.tar.gz"
  version "0.1.0"
  sha256 "acd183d33a81a7eb6565f2ca3319d7f6b4e9fc7802574f0b30b04ba7eebdd1b0"
  
  depends_on "python@3"

  def install
    bin.install "portal-cli"
    chmod 0755, bin/"portal-cli"
  end

  test do
    assert_match "usage: portal-cli", shell_output("#{bin}/portal-cli --help")
  end
end

