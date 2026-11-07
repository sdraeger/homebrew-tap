class Ddalab < Formula
  desc "Delay differential analysis of neurophysiological recordings: the ddalab command-line tool"
  homepage "https://ddalab.org/"
  version "2.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sdraeger/DDALAB/releases/download/v2.9.0/ddalab-aarch64-apple-darwin.tar.xz"
      sha256 "330e16df67b2395b1287f8d3392225a9b6ce73e5d1805778f43e9d9926980cf2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sdraeger/DDALAB/releases/download/v2.9.0/ddalab-x86_64-apple-darwin.tar.xz"
      sha256 "6c36e2e48d1c6af277f251db86ab294155390027b4e665dd666abfbdba1bd0ef"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/sdraeger/DDALAB/releases/download/v2.9.0/ddalab-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f2141616f0b52bd2fb72806d3a640ed4cef88ae05a8ad1d9dc701f0e4c3e4783"
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
