class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v1.21c.tar.gz"
  sha256 "3bfe783726f82c1f5a4be630ddc494ebb08dbb69980662cd7ffdeb7bc9e1e706"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]

  head "https://github.com/yrutschle/sslh.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e80ea37c3f9c0c055e05966935e74a795144cb296f6cc639d8223d0444384ef9"
    sha256 cellar: :any,                 big_sur:       "a1bca03e05e34bf629534709f11caf6ffc10508f598f315ecde85508218a397c"
    sha256 cellar: :any,                 catalina:      "27e1dfac1019af43e51729fa85884753ab1b14aa53c4f969d4bc8acdda514ed4"
    sha256 cellar: :any,                 mojave:        "06bf2bc9eb2c4cf200c3c05d22db1b3e30177418993d3ed02f068c9f4c12ce5f"
    sha256 cellar: :any,                 high_sierra:   "1b53222f84e259a92b6eab2cd172b4b860e7400bc73b76db141e79a5ed2b7693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3cc5aeb4810e156e438bc6c2a91d628cfaae1fe69a7141f86a868c7c7eb9174"
  end

  depends_on "libconfig"
  depends_on "pcre"

  uses_from_macos "netcat" => :test

  def install
    ENV.deparallelize
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    listen_port = free_port
    target_port = free_port

    fork do
      exec sbin/"sslh", "--http=localhost:#{target_port}", "--listen=localhost:#{listen_port}", "--foreground"
    end

    sleep 1
    system "nc", "-z", "localhost", listen_port
  end
end
