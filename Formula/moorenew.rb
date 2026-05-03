class Moorenew < Formula
  desc "Update your mailcow certificates from an external server easily"
  homepage "https://github.com/philxws692/moorenew"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/philxws692/moorenew/releases/download/v1.1.0/moorenew-aarch64-apple-darwin.tar.xz"
      sha256 "fdca84fd04aadf720bbefef3c2c9568765a8a8dcecc58fdcc2cc2916197f9c79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/philxws692/moorenew/releases/download/v1.1.0/moorenew-x86_64-apple-darwin.tar.xz"
      sha256 "42119f751e6d6cb5e90f02c59d27f4c0b15040bb24f96057260610fa050c5289"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/philxws692/moorenew/releases/download/v1.1.0/moorenew-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5fa9c3efc4e36b2f2fd840bb89b26335477b956fe8f7c1f23b64db45f11476b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/philxws692/moorenew/releases/download/v1.1.0/moorenew-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9b8d0dd4865cef95c0d9f395e309d1e3cb46d3d889a46f72a59a6fbed34855c5"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "moorenew" if OS.mac? && Hardware::CPU.arm?
    bin.install "moorenew" if OS.mac? && Hardware::CPU.intel?
    bin.install "moorenew" if OS.linux? && Hardware::CPU.arm?
    bin.install "moorenew" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
