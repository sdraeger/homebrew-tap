class Ddalab < Formula
  desc "Delay differential analysis of neurophysiological recordings: the ddalab command-line tool"
  homepage "https://ddalab.org/"
  version "2.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sdraeger/DDALAB/releases/download/v2.5.2/ddalab-aarch64-apple-darwin.tar.xz"
      sha256 "2a2242a69519b222ef814ea1b48042f4eccb75d171b17fc5cb2ead0a2a354d6d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sdraeger/DDALAB/releases/download/v2.5.2/ddalab-x86_64-apple-darwin.tar.xz"
      sha256 "3a0d454cda9dddce24a08920ac645edb721756a08e1b2dd00bcceed8404c1cd2"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/sdraeger/DDALAB/releases/download/v2.5.2/ddalab-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "de7612024c1bfa540dc33f4debfe2028139ba76d12ed2088b8b4a164e5c2e934"
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
