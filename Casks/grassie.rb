cask "grassie" do
  version "1.0.7"
  sha256 "d5129db17190e579e051b8be035a3bce7292fda7a6316958481f4473b4ebb530"

  url "https://github.com/mrKangHo/Grassie/releases/download/v#{version}/Grassie-v#{version}.zip"
  name "Grassie"
  desc "Native macOS Menu Bar GitHub Contribution Tracker App (Liquid Glass)"
  homepage "https://github.com/mrKangHo/Grassie"

  app "Grassie.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/Grassie.app"]
  end
end
