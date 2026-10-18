# Homebrew tap for Murti

[Murti](https://github.com/technomad641/murti) — on-device dictation for macOS
(English, Hindi, and Hinglish).

## Install

```sh
brew install technomad641/murti/murti
```

That's it — Homebrew adds this tap automatically. Then start it:

```sh
murti
```

The **first launch** creates Murti's Python environment and downloads the
on-device speech model (a few minutes, one time). After that, `murti` starts
instantly.

Grant **Microphone**, **Accessibility**, and **Input Monitoring** in
**System Settings ▸ Privacy & Security**, relaunch, and press **⌘⌥D** to dictate.

## Update / uninstall

```sh
brew upgrade murti
brew uninstall murti
```

## Requirements

- macOS 13+ on **Apple Silicon** (Whisper runs on the GPU via MLX)
- Homebrew

## Install the latest development version

```sh
brew install --HEAD technomad641/murti/murti
```

---

Everything runs on your device. No account, no upload. MIT licensed.
