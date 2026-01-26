class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "331d18488b1dc7f06cfa12cff909230816a24c57790ba3e8224b117e3f0ae03e"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  on_macos do
    depends_on "coreutils" => :build
    depends_on "gcc" if DevelopmentTools.clang_build_version <= 1403
  end

  on_ventura do
    depends_on "gcc"
    fails_with :clang
  end

  on_arm do
    depends_on "gcc"
    depends_on macos: :ventura
    fails_with :clang
  end

  # -ftree-loop-vectorize -flto=12 -s
  fails_with :clang do
    build 1403
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "9"
    cause "requires GCC 10+"
  end

  def install
    system "make", "CXX=#{ENV.cxx}", "STRIP=true"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    require "pty"
    require "io/console"

    config = (testpath/".config/btop")
    mkdir config/"themes"
    begin
      (config/"btop.conf").write <<~EOS
        #? Config file for btop v. #{version}

        update_ms=2000
        log_level=DEBUG
      EOS

      r, w, pid = PTY.spawn("#{bin}/btop")
      r.winsize = [80, 130]
      sleep 5
      w.write "q"
    rescue Errno::EIO
      # Apple silicon raises EIO
    end

    log = (config/"btop.log").read
    assert_match "===> btop++ v.#{version}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
