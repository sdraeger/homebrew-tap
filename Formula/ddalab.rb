class Ddalab < Formula
  desc "Delay differential analysis of neurophysiological recordings: the ddalab command-line tool"
  homepage "https://ddalab.org/"
  version "2.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sdraeger/DDALAB/releases/download/v2.8.0/ddalab-aarch64-apple-darwin.tar.xz"
      sha256 "e07f4e9b7e83b6e5b63db88f2f45a6aba92858566e30f08864581d9494e556ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sdraeger/DDALAB/releases/download/v2.8.0/ddalab-x86_64-apple-darwin.tar.xz"
      sha256 "d3f0d48ade9c23b139cff3c37c5bc72758a4a29b445f9d49140866e0fff8ff7c"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/sdraeger/DDALAB/releases/download/v2.8.0/ddalab-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ff8753c3964e7c8f8a36e63aa330d65c4706259d4e1fcaaa70408817c413c8ee"
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
