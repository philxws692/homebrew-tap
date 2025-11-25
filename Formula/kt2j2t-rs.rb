class Kt2j2tRs < Formula
  desc "Convert KaumaTests JSON files to json2tests-rs JSON files"
  homepage "https://philxws692.github.io/kt2j2t-rs/"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/philxws692/kt2j2t-rs/releases/download/v0.3.1/kt2j2t-rs-aarch64-apple-darwin.tar.xz"
      sha256 "0f402da1db42f8ae9e2cd2147401e6bfd28f74fc347148a67d666c92feb23718"
    end
    if Hardware::CPU.intel?
      url "https://github.com/philxws692/kt2j2t-rs/releases/download/v0.3.1/kt2j2t-rs-x86_64-apple-darwin.tar.xz"
      sha256 "d9b28fb4e56a7de220e794de3fe4a300686916435ad5de8d02bbbd7723a62af1"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/philxws692/kt2j2t-rs/releases/download/v0.3.1/kt2j2t-rs-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ff159a4997374add6810ca2d6400943fe405c41b70f0fecbf30c57ba1e1850cf"
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
