cask "arkvello" do
  version "0.1.0"
  sha256 "a9aa679e67d36cf57c9f6ae5267c372d176a7144370e0254ba7b1e55b256d2fe"

  url "https://github.com/IzusX/arkvello/releases/download/v#{version}/Arkvello-#{version}-universal.dmg"
  name "Arkvello"
  desc "Native archive manager powered by 7-Zip"
  homepage "https://github.com/IzusX/arkvello"

  depends_on macos: :sonoma

  app "Arkvello.app"

  caveats <<~EOS
    Arkvello is ad-hoc signed, without Developer ID or Apple notarization.
    If macOS blocks it, try opening it once, then use System Settings >
    Privacy & Security > Open Anyway, if you trust this release.
    See https://support.apple.com/en-us/102445
  EOS
end
