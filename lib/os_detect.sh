#!/bin/bash

# OS検出関数ライブラリ
# 実行環境のOSを検出する

# OS検出関数
# 戻り値: macos, wsl, debian, redhat, linux, windows, unknown
detect_os() {
  case "$(uname -s)" in
    Linux*)
      # WSL環境の検出
      if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "wsl"
      elif [ -f /etc/debian_version ]; then
        echo "debian"
      elif [ -f /etc/redhat-release ]; then
        echo "redhat"
      else
        echo "linux"
      fi
      ;;
    Darwin*)
      echo "macos"
      ;;
    CYGWIN*|MINGW*|MSYS*)
      echo "windows"
      ;;
    *)
      echo "unknown"
      ;;
  esac
}
