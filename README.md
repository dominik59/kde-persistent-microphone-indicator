# 🎙️ Persistent Microphone Indicator

A KDE Plasma 6 system tray applet that always shows microphone status — muted, idle, or actively recording — so you never have to guess whether your mic is live.

## ✅ Requirements

- KDE Plasma 6
- PipeWire or PulseAudio

## 📦 Installation

```bash
kpackagetool6 --type Plasma/Applet -i package/
```

After installation, enable the applet in the system tray:

1. Right-click the system tray (arrow icon in the panel) → **Configure System Tray…**
2. Go to **Extra Items** tab
3. Enable **Persistent Microphone Indicator**
4. Click **OK**

To update an already installed version:

```bash
kpackagetool6 --type Plasma/Applet -u package/
```

To remove:

```bash
kpackagetool6 --type Plasma/Applet -r com.github.dominik59.kde-persistent-microphone-indicator
```

## 🔒 License

GPL-2.0-or-later — see [LICENSE](LICENSE)
