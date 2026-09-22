class GitEdit < Formula
  desc "Fast, efficient, and safe Git history rewrites for AI agents"
  homepage "https://github.com/thomasbachem/git-edit"
  url "https://github.com/thomasbachem/git-edit/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "fe8118597f53308c22383e95510e5c15c0f64fef860237512703be64972d20ad"
  license "MIT"
  head "https://github.com/thomasbachem/git-edit.git", branch: "main"

  uses_from_macos "zsh"

  def install
    # `--selftest` sources its suite from beside the script, so both land in libexec and the
    # symlink leads `${0:A}` back there
    libexec.install "git-edit", "selftest.zsh"
    if OS.linux?
      inreplace libexec/"git-edit", "#!/bin/zsh", "#!#{formula_opt_bin("zsh")}/zsh"
    end
    bin.install_symlink libexec/"git-edit"
    man1.install "man/man1/git-edit.1"
  end

  test do
    assert_match "git-edit #{version}", shell_output("#{bin}/git-edit --version")

    system "git", "init", "-q", "-b", "main"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Test"
    (testpath/"file.txt").write "one\n"
    system "git", "add", "file.txt"
    system "git", "commit", "-qm", "Wrong subject"

    system bin/"git-edit", "-M", "--text=Right subject", "HEAD"
    assert_equal "Right subject", shell_output("git log -1 --format=%s").strip
  end
end
