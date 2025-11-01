class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.9.0/lnav-0.9.0.tar.gz"
  sha256 "03e15449a87fa511cd19c6bb5e95de4fffe17612520ff7683f2528d3b2a7238f"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end


  head do
    url "https://github.com/tstack/lnav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "pcre"
  depends_on "readline"
  depends_on "sqlite"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-sqlite=#{Formula["sqlite"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lnav", "-V"
  end
end
