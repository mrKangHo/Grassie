cask "grassie" do
  version "1.0.1"
  sha256 "9ff46f6920d17af081e24582fcd931a314aeede2edc33292a78950ac5fea5a0a"

  url "https://github.com/mrKangHo/Grassie/releases/download/v#{version}/Grassie-v#{version}.zip"
  name "Grassie"
  desc "Native macOS Menu Bar GitHub Contribution Tracker App (Liquid Glass)"
  homepage "https://github.com/mrKangHo/Grassie"

  app "Grassie.app"
end
