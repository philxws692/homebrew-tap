class Moorenew < Formula
  desc "Update your mailcow certificates from an external server easily"
  homepage "https://github.com/philxws692/moorenew"
  version "1.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/philxws692/moorenew/releases/download/v1.1.1/moorenew-aarch64-apple-darwin.tar.xz"
      sha256 "fd4866f9dddfa79c7a61d8cbeeef8563b355fb17b092c77ce1d7e1d43075e97c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/philxws692/moorenew/releases/download/v1.1.1/moorenew-x86_64-apple-darwin.tar.xz"
      sha256 "270ca8491e82c0996ddeda0430d5d795d3eca9e7ee79b83dfa7357a00704a6a1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/philxws692/moorenew/releases/download/v1.1.1/moorenew-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "673a0da6e513ff38189e82a66ab251f01f20cd8b6329a51092a7475e3182c408"
    end
    if Hardware::CPU.intel?
      url "https://github.com/philxws692/moorenew/releases/download/v1.1.1/moorenew-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fa4e52e150cd84ed7001bb9f07682790c5be15887f9f9b63648fa24e33c49895"
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
