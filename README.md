# 🌱 Grassie — Native macOS GitHub Contribution Tracker

[![macOS 13+](https://img.shields.io/badge/macOS-13.0%2B-blue.svg)](https://apple.com)
[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Homebrew Compatible](https://img.shields.io/badge/Homebrew-brew%20install-amber.svg)](grassie.rb)

> **Languages**: [English](README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [中文](README.zh.md)

**Grassie** is a ultra-fast, native macOS Menu Bar application built with SwiftUI & AppKit that tracks your GitHub contribution grass grid and active streak in real-time right from your Mac's top bar.

---

![Grassie Mascot App Icon](grasstracker_app_icon.jpg)

## ✨ Key Features

- 💧 **Liquid Glass UI**: Beautiful translucent frosted glass background (`NSVisualEffectView`) with liquid caustic light gradients.
- 🟩 **Dynamic 3x3 Status Bar Icon**: Status bar icon renders your real recent 9 days of GitHub contribution levels live in your macOS top bar.
- 🌱 **Dynamic Streak Badge Engine**: Emojis evolve based on your streak progress (`0d 🌱` -> `1-6d 🌿` -> `7-29d 🔥` -> `30-99d 🚀` -> `100d+ 👑`).
- 🗓️ **Timeframe Range Selector**: Switch instantly between `1M`, `3M`, `6M`, and `1Y` view periods with auto-scaling responsive grid squares.
- 🎨 **Appearance Modes**: System Auto (Follows macOS Dark/Light appearance), Liquid Dark, and Liquid Light.
- 🌐 **Multi-Language Support**: Fully localized in English, Korean (한국어), Japanese (日本語), and Chinese (中文).
- 🚀 **macOS System Login Startup**: Native `SMAppService` integration to start silently at boot.

---

## 💻 Installation

### Option 1: Homebrew (Recommended)
```bash
brew tap username/grassie
brew install grassie
```

### Option 2: Build from Source
```bash
git clone https://github.com/username/Grassie.git
cd Grassie
swift build -c release
open Grassie.app
```

---

## 🛠️ Usage & Setup
1. Launch **Grassie** from your Applications folder or Menu Bar.
2. Click the **⚙️ Settings** icon in the popover header.
3. Enter your **GitHub Username** and click **Save Changes**.
4. Enjoy live contribution tracking right from your macOS status bar!

---

## 📄 License
Distributed under the MIT License. See `LICENSE` for more information.
