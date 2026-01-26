class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.13.tar.gz"
  sha256 "668dc4782432564c35ad0d32748f972248cc5c5448c9009faeb3445282920e02"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"


  on_macos do
    depends_on "coreutils" => :build
#    depends_on "gcc"
  end

  fails_with :clang # -ftree-loop-vectorize -flto=12 -s

  fails_with :gcc do
    version "9"
    cause "requires GCC 10+"
  end

  def install
    #system "make", "CXX=#{ENV.cxx}", "STRIP=true"
    system "make", "CXX=/usr/local/Cellar/gcc@14/14.3.0/bin/g++-14 -v", "STRIP=true"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    config = (testpath/".config/btop")
    mkdir config/"themes"
    (config/"btop.conf").write <<~EOS
      #? Config file for btop v. #{version}

      update_ms=2000
      log_level=DEBUG
    EOS

    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/btop")
    r.winsize = [80, 130]
    sleep 5
    w.write "q"

    log = (config/"btop.log").read
    assert_match "===> btop++ v.#{version}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
