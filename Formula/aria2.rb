class Aria2 < Formula
  desc "Download with resuming and segmented downloading, use openssl for macOS"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0.tar.xz"
  sha256 "60a420ad7085eb616cb6e2bdf0a7206d68ff3d37fb5a956dc44242eb2f79b66b"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  depends_on "pkgconf" => :build
  depends_on "libssh2"
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV.cxx11
    ENV.append "LDFLAGS", "-framework Security" if OS.mac? && Hardware::CPU.arm?

    args = %w[
      --disable-silent-rules
      --with-libssh2
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
      --without-appletls
      --with-openssl
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    bash_completion.install "doc/bash_completion/aria2c"
  end

  test do
    system bin/"aria2c", "https://brew.sh/"
    assert_path_exists testpath/"index.html", "Failed to create index.html!"
  end
end
