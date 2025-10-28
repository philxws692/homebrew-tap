class Kt2j2tRs < Formula
  desc "Convert KaumaTests JSON files to json2tests-rs JSON files"
  homepage "https://github.com/philxws692/kt2j2t-rs"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/philxws692/kt2j2t-rs/releases/download/v0.3.0/kt2j2t-rs-aarch64-apple-darwin.tar.xz"
      sha256 "16a6f2e462cc13509cc88dad9c669cb49246608efd8629784a2f733d381b6d91"
    end
    if Hardware::CPU.intel?
      url "https://github.com/philxws692/kt2j2t-rs/releases/download/v0.3.0/kt2j2t-rs-x86_64-apple-darwin.tar.xz"
      sha256 "0438aa2c0041d6373042ab2bb9488b997f2964e5dcb5fd745c0b55810306c42e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/philxws692/kt2j2t-rs/releases/download/v0.3.0/kt2j2t-rs-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "9baa8299a7e0e446c16b8af794e1453bd9323cb6a9ce7ede641c003bdf26ea95"
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
