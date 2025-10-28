class Kt2j2tRs < Formula
  desc "Convert KaumaTests JSON files to json2tests-rs JSON files"
  homepage "https://github.com/philxws692/kt2j2t-rs"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/philxws692/kt2j2t-rs/releases/download/v0.2.0/kt2j2t-rs-aarch64-apple-darwin.tar.xz"
      sha256 "a4ff2e4a3b1c531a6d131a58d2d507e523256ae44e8442bd8cacbd826dd70b6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/philxws692/kt2j2t-rs/releases/download/v0.2.0/kt2j2t-rs-x86_64-apple-darwin.tar.xz"
      sha256 "a2103663b9e1cc92934d168bfa31a2487b1500157850174fe8774c904d3b1b75"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/philxws692/kt2j2t-rs/releases/download/v0.2.0/kt2j2t-rs-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "c61fe2abfe42db1e0332e82f7be1134c1ce16f804c9a04af0422d652cb67a690"
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
