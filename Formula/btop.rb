class Btop < Formula
  desc "Resource monitor for macOS Catalina"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.13.tar.gz"
  sha256 "f3f6f2a5d7c6b5a5d5f5d5d5f5d5d5f5d5d5f5d5d5f5d5d5f5d5d5f5d5d5f5d5d5f"
  license "Apache-2.0"

  depends_on "gcc" => :build

  def install
    # 直接使用 g++-14
    cxx = "/usr/local/bin/g++-14"
    
    unless File.exist?(cxx)
      # 如果 g++-14 不在 /usr/local/bin，在其他地方查找
      if File.exist?("#{Formula["gcc"].opt_bin}/g++-14")
        cxx = "#{Formula["gcc"].opt_bin}/g++-14"
      else
        # 查找其他版本
        gcc_versions = Dir["/usr/local/bin/g++-*"].sort
        cxx = gcc_versions.last if gcc_versions.any?
      end
    end
    
    ohai "使用编译器: #{cxx}"
    
    # 修改 Makefile
    inreplace "Makefile", "-std=c++23", "-std=c++20"
    inreplace "Makefile", "-flto=$(THREADS)", ""
    inreplace "Makefile", "-ftree-loop-vectorize", ""
    
    # 编译
    system "make", "CXX=#{cxx}", "STRIP=true"
    system "make", "PREFIX=#{prefix}", "install"
  end
  
  test do
    assert_match "btop", shell_output("#{bin}/btop --version 2>&1", 1)
  end
end
