class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "6.0.2",
      revision: "fc13ea9684066d28b3bcb61670202d28c6110d60"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  # 仅保留运行时必需的依赖
  depends_on "gd"
  depends_on "gts"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "pango"

  def install
    # 关键修复：在配置前删除有问题的 Windows 子模块目录
    # 这样 autogen.sh 就不会尝试初始化它
    rm_rf "windows" if Dir.exist?("windows")

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-x
      --with-gts
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"sample.dot").write <<~EOS
      digraph G {
        a -> b
      }
    EOS

    system "#{bin}/dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end
