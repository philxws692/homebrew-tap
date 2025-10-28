class Kt2j2tRs < Formula
  desc "Convert KaumaTests JSON files to json2tests-rs JSON files"
  homepage "https://github.com/philxws692/kt2j2t-rs"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/philxws692/kt2j2t-rs/releases/download/v0.1.0/kt2j2t-rs-aarch64-apple-darwin.tar.xz"
      sha256 "79a2b38d2d0dae22d6f223a47723f90aa4fd36cc7c8d0b023d43fb2080cc74a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/philxws692/kt2j2t-rs/releases/download/v0.1.0/kt2j2t-rs-x86_64-apple-darwin.tar.xz"
      sha256 "7adac93f7d4d5327c74f3172ee2b464cdf32e90f75d8d5c95309ee0d1424b2f5"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/philxws692/kt2j2t-rs/releases/download/v0.1.0/kt2j2t-rs-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "38d11424446c2d237aaaff32352b9cc17ca4c62cf82d7597d0a6768879de1665"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "kt2j2t" if OS.mac? && Hardware::CPU.arm?
    bin.install "kt2j2t" if OS.mac? && Hardware::CPU.intel?
    bin.install "kt2j2t" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
