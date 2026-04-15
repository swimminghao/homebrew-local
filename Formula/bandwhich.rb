class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "f9c50c340372593bf4c54fcf2608ef37c2c56a37367b2f430c27cce3ea947828"
  license "MIT"

#  bottle do
#    rebuild 1
#    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3002676cce8ef6b4952f536c28dcead967333aef77a6651e1c3c2c7608d185a"
#    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f496b2e21cc348358f32175ff44c0f1e88ba3c2c8b9a07c083fba78b271506f0"
#    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a81e3e8c8b0639383dee9945a0a6f40e64c2c7d4d6706168ad13dd069007207"
#    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "430ee18eb71232cfb3ded1fb80ae051d59c4d193a65330cac387ec3331017500"
#    sha256 cellar: :any_skip_relocation, sonoma:         "49bfc041ccb99d48ced976dc37f4e4bf60a1aaefab6c91bee22650d99cdd0063"
#    sha256 cellar: :any_skip_relocation, ventura:        "3daf225eb58ef12c781439c9101d3b2784b8a3dc330150fafaa86b9529a9a655"
#    sha256 cellar: :any_skip_relocation, monterey:       "b7b38e5e3f682261a03ca1df79d71f9c48dfe9d8350c436f07a9c8288c5f0d87"
#    sha256 cellar: :any_skip_relocation, big_sur:        "c1256a409795dd2f5e6c021c2038349c3a2ba38c6c0b54dfa0288fd10f23e3f4"
#    sha256 cellar: :any_skip_relocation, catalina:       "27ed0f76c29c31c7427853592e7b86d8f291414c356ac714f053b606bf495234"
#    sha256 cellar: :any_skip_relocation, x86_64_linux:   "053c72d686f7e10f7f8457329715b727fefad9ce4952e41a8d031599eb1f8b22"
#  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 2
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
