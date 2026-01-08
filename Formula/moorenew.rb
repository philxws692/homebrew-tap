class Moorenew < Formula
  desc "Update your mailcow certificates from an external server easily"
  homepage "https://github.com/philxws692/moorenew"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/philxws692/moorenew/releases/download/v1.0.0/moorenew-aarch64-apple-darwin.tar.xz"
      sha256 "74a59462fa033bd459e15081582194ba018b4481d4eeaa0820f3c16f5cdfbf7c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/philxws692/moorenew/releases/download/v1.0.0/moorenew-x86_64-apple-darwin.tar.xz"
      sha256 "cee8e7958693b4fe06e3629d4381f8c0290bf8f1db4abdc47913241b92fc045f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/philxws692/moorenew/releases/download/v1.0.0/moorenew-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ea25b0590fa791b53bee7aa9777b54326ba90ac14b15660fc0dd6568e270094f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/philxws692/moorenew/releases/download/v1.0.0/moorenew-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b33bc886c10821f65d1d41bbb45a4de20b7def5ce320d6f34ecb22a43bccdc38"
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
