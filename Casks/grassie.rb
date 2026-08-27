cask "grassie" do
  version "1.0.3"
  sha256 "f72d88c75f0e74034c13abe427f9019ab6098cc84e5f537ea2e48f0e9853aba5"

  url "https://github.com/mrKangHo/Grassie/releases/download/v#{version}/Grassie-v#{version}.zip"
  name "Grassie"
  desc "Native macOS Menu Bar GitHub Contribution Tracker App (Liquid Glass)"
  homepage "https://github.com/mrKangHo/Grassie"

  app "Grassie.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/Grassie.app"]
  end
end
