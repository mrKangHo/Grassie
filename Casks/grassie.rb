cask "grassie" do
  version "1.0.1"
  sha256 "754a929d7d80b9d964406ff5f47e364d15c0604b91add5052f8d59686fe78e0f"

  url "https://github.com/mrKangHo/Grassie/releases/download/v#{version}/Grassie-v#{version}.zip"
  name "Grassie"
  desc "Native macOS Menu Bar GitHub Contribution Tracker App (Liquid Glass)"
  homepage "https://github.com/mrKangHo/Grassie"

  app "Grassie.app"
end
