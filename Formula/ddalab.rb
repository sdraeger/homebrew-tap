class Ddalab < Formula
  desc "Delay differential analysis of neurophysiological recordings: the ddalab command-line tool"
  homepage "https://ddalab.org/"
  version "2.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sdraeger/DDALAB/releases/download/v2.5.1/ddalab-aarch64-apple-darwin.tar.xz"
      sha256 "727b6355bf35ad85fa4dd855a2e696c651a39599fa2b42376055de5d24229b9e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sdraeger/DDALAB/releases/download/v2.5.1/ddalab-x86_64-apple-darwin.tar.xz"
      sha256 "fdc3eaa3db815bddb33c3af0d84fb3242d0206f3e2fc8fd85583c67d8c759735"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/sdraeger/DDALAB/releases/download/v2.5.1/ddalab-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2c6b51e20eddb0ff76471a28dbf2c90dbd176811a4badd0c7136c32c95f160f0"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ddalab"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ddalab"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ddalab"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
