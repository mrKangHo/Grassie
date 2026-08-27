cask "grassie" do
  version "1.0.1"
  sha256 "d90fe628416ad7c50d252213c8f53c1b30506b787d4ea9d9454d04fdb523326a"

  url "https://github.com/mrKangHo/Grassie/releases/download/v#{version}/Grassie-v#{version}.zip"
  name "Grassie"
  desc "Native macOS Menu Bar GitHub Contribution Tracker App (Liquid Glass)"
  homepage "https://github.com/mrKangHo/Grassie"

  app "Grassie.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/Grassie.app"]
  end
end
