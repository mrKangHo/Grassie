class Grassie < Formula
  desc "Native macOS Menu Bar GitHub Contribution Tracker App (Liquid Glass)"
  homepage "https://github.com/mrKangHo/Grassie"
  url "https://github.com/mrKangHo/Grassie/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "0d35c79206b7f602c315ac21df8beb79b82af57e48e0baeaebf4a5394945bd82"
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
