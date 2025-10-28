class Kt2j2tRs < Formula
  desc "Convert KaumaTests JSON files to json2tests-rs JSON files"
  homepage "https://github.com/philxws692/kt2j2t-rs"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/philxws692/kt2j2t-rs/releases/download/v0.2.1/kt2j2t-rs-aarch64-apple-darwin.tar.xz"
      sha256 "955c5932fdc34374e54cd6949089c1ddccd761b55a167397d3369547a3939936"
    end
    if Hardware::CPU.intel?
      url "https://github.com/philxws692/kt2j2t-rs/releases/download/v0.2.1/kt2j2t-rs-x86_64-apple-darwin.tar.xz"
      sha256 "cb5a006a4acac380b83d56d1d123567cc3d908ba730a60395206876fadb8077c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/philxws692/kt2j2t-rs/releases/download/v0.2.1/kt2j2t-rs-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "834a05484bf3ec93beed74d04e3070e457f735f18bfc1c0e53976bff6d632b02"
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
