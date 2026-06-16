class HornbillCli < Formula
  desc "CLI client for Hornbill bill tracker"
  homepage "https://github.com/tubruk/hornbill"
  version "0.2.1"
  license "AGPL-3.0-only"

  url "https://github.com/tubruk/hornbill/releases/download/v0.2.1/hornbill-linux-x64"
  sha256 "55f588ac33eef9f38fa33c6cc962dba1a36e1f8ce97072bef0f1eaef9747218b"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/tubruk/hornbill/releases/download/v0.2.1/hornbill-darwin-arm64"
      sha256 "1e7131a3c7a9df9aa32a08a76670a58889884b02ee356298e38f896b5e9ee8cf"
    else
      url "https://github.com/tubruk/hornbill/releases/download/v0.2.1/hornbill-darwin-x64"
      sha256 "4511ab73851ccfda94b7a4f1f7790ababc30a8e1e1ce38105229ea90f1bc476c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/tubruk/hornbill/releases/download/v0.2.1/hornbill-linux-arm64"
      sha256 "e3ce6391d5b9061446d0419b01c37151fd24786fead573b74284cea48cfdff61"
    else
      url "https://github.com/tubruk/hornbill/releases/download/v0.2.1/hornbill-linux-x64"
      sha256 "55f588ac33eef9f38fa33c6cc962dba1a36e1f8ce97072bef0f1eaef9747218b"
    end
  end

  head "https://github.com/tubruk/hornbill.git", branch: "main"

  depends_on "bun" => :build if build.head?

  def install
    if build.head?
      system "bun", "install"
      system "bun", "run", "--cwd", "packages/cli", "build"
      bin.install "packages/cli/bin/hornbill"
    else
      # Homebrew renames single-file downloads to the formula name (hornbill-cli)
      # but we check both names to be safe.
      if File.exist?("hornbill-cli")
        bin.install "hornbill-cli" => "hornbill"
      else
        binary_name = if OS.mac?
          Hardware::CPU.arm? ? "hornbill-darwin-arm64" : "hornbill-darwin-x64"
        else
          Hardware::CPU.arm? ? "hornbill-linux-arm64" : "hornbill-linux-x64"
        end
        bin.install binary_name => "hornbill"
      end
    end
  end

  test do
    system "#{bin}/hornbill", "--help"
  end
end
