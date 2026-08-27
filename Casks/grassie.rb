cask "grassie" do
  version "1.0.5"
  sha256 "6b287a9e20dec6665368009a2cd7496be9a08a6f06677d3be44501a30415e760"

  url "https://github.com/mrKangHo/Grassie/releases/download/v#{version}/Grassie-v#{version}.zip"
  name "Grassie"
  desc "Native macOS Menu Bar GitHub Contribution Tracker App (Liquid Glass)"
  homepage "https://github.com/mrKangHo/Grassie"

  app "Grassie.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/Grassie.app"]
  end
end
