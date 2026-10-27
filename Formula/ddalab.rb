class Ddalab < Formula
  desc "Delay differential analysis of neurophysiological recordings: the ddalab command-line tool"
  homepage "https://sdraeger.github.io/DDALAB/"
  version "2.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sdraeger/DDALAB/releases/download/v2.5.0/ddalab-aarch64-apple-darwin.tar.xz"
      sha256 "edbea4f737093f34bb953d8987b6d395e5f89ab25cfd1b99bf7e0ebf985bde04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sdraeger/DDALAB/releases/download/v2.5.0/ddalab-x86_64-apple-darwin.tar.xz"
      sha256 "4502908373d2bc008d91c424b3c97640a9edd04d765a6ff260f78fce8362d3df"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/sdraeger/DDALAB/releases/download/v2.5.0/ddalab-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "443c3f8b9aec344f5b2f09e383edb1235ab5072de3155d82e37c993af8001546"
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
