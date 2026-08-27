class Grassie < Formula
  desc "Native macOS Menu Bar GitHub Contribution Tracker App (Liquid Glass)"
  homepage "https://github.com/mrKangHo/Grassie"
  url "https://github.com/mrKangHo/Grassie/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "452c194b94af2ca56abb1723d41c643e39dcde8b9852a10004342ff7f1211f0c"
  license "MIT"

  depends_on :xcode => ["14.0", :build]
  depends_on :macos => :ventura

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/Grassie"
  end

  test do
    system "#{bin}/Grassie", "--version"
  end
end
