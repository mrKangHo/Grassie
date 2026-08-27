cask "grassie" do
  version "1.0.4"
  sha256 "d85b77cb49fbf6a0fb691c3cb277f7fa18387caf64b7cf37d54577fc280e8e32"

  url "https://github.com/mrKangHo/Grassie/releases/download/v#{version}/Grassie-v#{version}.zip"
  name "Grassie"
  desc "Native macOS Menu Bar GitHub Contribution Tracker App (Liquid Glass)"
  homepage "https://github.com/mrKangHo/Grassie"

  app "Grassie.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/Grassie.app"]
  end
end
