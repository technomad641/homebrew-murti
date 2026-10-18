class Murti < Formula
  desc "On-device dictation for macOS — English, Hindi, and Hinglish"
  homepage "https://github.com/technomad641/murti"
  url "https://github.com/technomad641/murti/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "64b796043d2290444301981a10dbbd634b5e1c095a7fa08543b038aa349a326a"
  license "MIT"
  head "https://github.com/technomad641/murti.git", branch: "main"

  depends_on arch: :arm64 # Whisper runs on the Apple Silicon GPU via MLX
  depends_on "libsndfile" # for soundfile
  depends_on :macos
  depends_on "portaudio" # for sounddevice
  depends_on "python@3.12"

  def install
    # Install the source tree. Murti's Python environment is created on first
    # run, not here: Homebrew's build sandbox blocks network access, and the
    # on-device ML dependencies are large, so pip runs at first launch instead.
    libexec.install Dir["*"]

    (bin/"murti").write <<~SH
      #!/bin/bash
      set -e
      APP="#{libexec}"
      DATA="${XDG_DATA_HOME:-$HOME/.local/share}/murti"
      VENV="$DATA/venv"
      PY="#{formula_opt_bin("python@3.12")}/python3.12"
      if [ ! -x "$VENV/bin/python" ]; then
        echo "Murti: first-run setup — creating environment and downloading" >&2
        echo "dependencies. This happens once and takes a few minutes…" >&2
        mkdir -p "$DATA"
        "$PY" -m venv "$VENV"
        "$VENV/bin/pip" install --quiet --upgrade pip
        "$VENV/bin/pip" install --quiet -r "$APP/requirements.txt"
      fi
      exec env PYTHONPATH="$APP" "$VENV/bin/python" -m murti.app "$@"
    SH
  end

  def caveats
    <<~EOS
      Murti is a menu-bar dictation app. Start it with:
        murti

      The first launch sets up its Python environment and downloads the
      on-device speech model (a few minutes, one time only).

      Then grant these in System Settings ▸ Privacy & Security and relaunch:
        • Microphone        — to hear you
        • Accessibility     — to type the result into other apps
        • Input Monitoring  — for the global ⌘⌥D shortcut

      Press ⌘⌥D to start dictating, press it again to stop.
    EOS
  end

  test do
    assert_path_exists bin/"murti"
    assert_match "murti.app", (bin/"murti").read
  end
end
