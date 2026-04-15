class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://jqlang.github.io/jq/"
  url "https://github.com/jqlang/jq/releases/download/jq-1.7/jq-1.7.tar.gz"
  sha256 "402a0d6975d946e6f4e484d1a84320414a0ff8eb6cf49d2c11d144d4d344db62"
  license "MIT"

  livecheck do
    url :stable
    regex(/^(?:jq[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

#  bottle do
#    rebuild 1
#    sha256 cellar: :any,                 arm64_ventura:  "4622927182fbc7bf27c4b706e005fbae2700d15e69a68ef7002aed2676b8a4f7"
#    sha256 cellar: :any,                 arm64_monterey: "f70e1ae8df182b242ca004492cc0a664e2a8195e2e46f30546fe78e265d5eb87"
#    sha256 cellar: :any,                 arm64_big_sur:  "674b3ae41c399f1e8e44c271b0e6909babff9fcd2e04a2127d25e2407ea4dd33"
#    sha256 cellar: :any,                 ventura:        "b70ec02353c5f6cb69d947e1506e71c96d2952ed4099ae3948c6c61420b16ef9"
#    sha256 cellar: :any,                 monterey:       "7fee6ea327062b37d34ef5346a84810a1752cc7146fff1223fab76c9b45686e0"
#    sha256 cellar: :any,                 big_sur:        "bf0f8577632af7b878b6425476f5b1ab9c3bf66d65affb0c455048a173a0b6bf"
#    sha256 cellar: :any,                 catalina:       "820a3c85fcbb63088b160c7edf125d7e55fc2c5c1d51569304499c9cc4b89ce8"
#    sha256 cellar: :any,                 mojave:         "71f0e76c5b22e5088426c971d5e795fe67abee7af6c2c4ae0cf4c0eb98ed21ff"
#    sha256 cellar: :any,                 high_sierra:    "dffcffa4ea13e8f0f2b45c5121e529077e135ae9a47254c32182231662ee9b72"
#    sha256 cellar: :any,                 sierra:         "bb4d19dc026c2d72c53eed78eaa0ab982e9fcad2cd2acc6d13e7a12ff658e877"
#    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2beea2c2c372ccf1081e9a5233fc3020470803254284aeecc071249d76b62338"
#  end

  head do
    url "https://github.com/jqlang/jq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-maintainer-mode"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end
