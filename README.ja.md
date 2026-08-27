# 🌱 Grassie — Native macOS GitHub 草トラックアプリ

[![macOS 13+](https://img.shields.io/badge/macOS-13.0%2B-blue.svg)](https://apple.com)
[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Homebrew Compatible](https://img.shields.io/badge/Homebrew-brew%20install-amber.svg)](grassie.rb)

> **言語**: [English](README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [中文](README.zh.md)

**Grassie（グラシー）**は、macOSメニューバーでGitHubの貢献草グラフと連続達成（Streak）をリアルタイムで確認できる超高速ネイティブmacOSアプリです。

---

![Grassie Mascot App Icon](grasstracker_app_icon.jpg)

## ✨ 主な機能

- 💧 **Liquid Glass UI**: macOSすりガラスブラー（`NSVisualEffectView`）と液体グラデーションの美しいデザイン
- 🟩 **リアルタイム 3x3 メニューバーアイコン**: 過去9日間の実際の貢献レベルがメニューバーの9つのマス目にリアルタイム描画
- 🌱 **動的Streak絵文字エンジン**: 達成日数に応じてステータスバーの絵文字が自動変化（`0日 🌱` ➡️ `1-6日 🌿` ➡️ `7-29日 🔥` ➡️ `30-99日 🚀` ➡️ `100日+ 👑`）
- 🗓️ **期間切り替えレスポンシブ表示**: `1M`、`3M`、`6M`、`1Y`の各期間に応じてマス目のサイズとウィンドウの高さが自動調整
- 🎨 **外観モード**: システム自動、Liquid Dark、Liquid Lightに対応
- 🌐 **多言語対応**: 英語、韓国語、日本語、中国語に対応
- 🚀 **ログイン時自動起動**: ネイティブ`SMAppService`連携により、macOS起動時に自動実行

---

## 💻 インストール方法

### 方法 1: Homebrew（推奨）
```bash
brew tap username/grassie
brew install grassie
```

### 方法 2: ソースコードからビルド
```bash
git clone https://github.com/username/Grassie.git
cd Grassie
swift build -c release
open Grassie.app
```

---

## 📄 ライセンス
MIT Licenseの元で配布されています。詳細は`LICENSE`をご確認ください。
