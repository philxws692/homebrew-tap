class Moorenew < Formula
  desc "Update your mailcow certificates from an external server easily"
  homepage "https://github.com/philxws692/moorenew"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/philxws692/moorenew/releases/download/v1.0.1/moorenew-aarch64-apple-darwin.tar.xz"
      sha256 "1757488ded79618396806fd695ef3b5f57ad0c7dab5716e1e705f5dce138e11d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/philxws692/moorenew/releases/download/v1.0.1/moorenew-x86_64-apple-darwin.tar.xz"
      sha256 "681ff88308ec3030df7a48ceb497842a963cf60ab4acb5b87ee428b5388bc9ba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/philxws692/moorenew/releases/download/v1.0.1/moorenew-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ab1b7253c931d4f472dac8f9aba8bbdcee91872b0c1fa692d353fa5012d9f8d3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/philxws692/moorenew/releases/download/v1.0.1/moorenew-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ff708238661a7a8566609ce12733ce5e5079973da4f28f080c1811b4e3df45d4"
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
