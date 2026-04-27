To check it during testing use:
```bash
plasmoidviewer -a ./package
```

To test a package:
```
mkdir -p ~/.local/share/plasma/plasmoids/com.github.dominik59.kde-persistent-microphone-indicator
cp -r ./package/* ~/.local/share/plasma/plasmoids/com.github.dominik59.kde-persistent-microphone-indicator/
plasmawindowed --statusnotifier com.github.dominik59.persistkde-persistent-microphone-indicatorentmic
```

To run a package:
```
mkdir -p ~/.local/share/plasma/plasmoids/com.github.dominik59.kde-persistent-microphone-indicator
cp -r ./package/* ~/.local/share/plasma/plasmoids/com.github.dominik59.kde-persistent-microphone-indicator/
kquitapp6 plasmashell
kstart plasmashell
```