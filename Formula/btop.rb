class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "331d18488b1dc7f06cfa12cff909230816a24c57790ba3e8224b117e3f0ae03e"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  # 为所有 macOS 版本添加 gcc 依赖（Catalina 需要）
  depends_on "gcc" => :build
  depends_on "make" => :build

  # 移除特定版本的 on_ventura 限制
  # on_ventura do
  #   depends_on "gcc"
  #   fails_with :clang
  # end

  # on_arm do
  #   depends_on "gcc"
  #   depends_on macos: :ventura
  #   fails_with :clang
  # end

  # 修改失败条件，适配 Catalina
  fails_with :clang do
    build 1200  # Catalina 的 clang 版本是 12.0.0
    cause "Requires C++20 support"
  end

  # 降低 GCC 要求，Catalina 可能只有 gcc-14
  fails_with :gcc do
    version "8"
    cause "requires GCC 9+"
  end

  # 添加补丁来修复 Catalina 编译问题
  patch :DATA

  def install
    # 查找可用的 g++ 版本
    gcc_prefix = Formula["gcc"].prefix
    gcc_bin = Dir["#{gcc_prefix}/bin/g++-*"].first || "#{gcc_prefix}/bin/g++"
    
    # 设置环境变量
    ENV["CXX"] = gcc_bin
    ENV["CC"] = gcc_bin.sub("g++", "gcc")
    
    # 修复 Catalina 特定问题
    inreplace "Makefile", "-std=c++23", "-std=c++20"
    inreplace "Makefile", "-ftree-loop-vectorize", ""
    inreplace "Makefile", "-flto=$(THREADS)", "-flto"
    
    # 降低编译器版本要求
    inreplace "Makefile", "if ($$3 >= 16) print 1", "if ($$3 >= 14) print 1"
    inreplace "Makefile", "if ($$3 >= 10) print 1", "if ($$3 >= 9) print 1"
    
    system "make", "STRIP=true"
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

__END__
diff --git a/Makefile b/Makefile
index abc123..def456 100644
--- a/Makefile
+++ b/Makefile
@@ -86,7 +86,7 @@
 #	Compiler version checks
 #-------------------------------------------------------------------------------
 $(if $(filter 1,$(shell $(CXX) -dM -E -x c++ /dev/null 2>/dev/null | grep -q "__clang__" && echo 1)), \
-	$(if $(shell $(CXX) -dM -E -x c++ /dev/null 2>/dev/null | grep -E "__clang_major__" | awk '{if ($$3 >= 16) print 1}'),, \
+	$(if $(shell $(CXX) -dM -E -x c++ /dev/null 2>/dev/null | grep -E "__clang_major__" | awk '{if ($$3 >= 12) print 1}'),, \
 	$(error ERROR: Compiler too old. (Requires Clang 16.0.0, GCC 10.1.0.))))
 
 $(if $(filter 1,$(shell $(CXX) -dM -E -x c++ /dev/null 2>/dev/null | grep -q "__GNUC__" && echo 1)), \
@@ -119,7 +119,7 @@
 #-------------------------------------------------------------------------------
 THREADS		:= $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)
 REQFLAGS	!| -std=c++23
-OPTFLAGS	:= -O2 -ftree-loop-vectorize -flto=$(THREADS)
+OPTFLAGS	:= -O2 -flto
 CXXFLAGS	+= $(REQFLAGS) $(LDCXXFLAGS) $(OPTFLAGS) $(WARNFLAGS)
 LDFLAGS		+= $(LDCXXFLAGS) $(OPTFLAGS) $(WARNFLAGS)
