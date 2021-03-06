![Cover](ld48/res/web/loader_cover.png)

# DRILLER - 3D first-person shooter made with Defold

## Ludum Dare 48

The game is for LD48 the **COMPO** category. It's built using the [Defold game engine](https://defold.com/).

Play the latest version online:
- [**Github**](https://aglitchman.github.io/defold-ld48-game/) or [**Itch.io**](https://glitchman.itch.io/driller).
- [**LD48 page**](https://ldjam.com/events/ludum-dare/48/driller) - vote for it and leave comments! 😊

### Controls

* **WASD** - to move around.
* **Mouse** - to look around.
* **Mouse LEFT button** - to shoot and interact.

![GIF](https://forum.defold.com/uploads/default/original/3X/f/1/f1e54956511d91f454f9f23938e25dff7d985e56.gif)

## Dev Notes

### Structure (WIP)

```yaml
/ld48: # Main folder

  # C++ and HTML5 sources
  /manifests:
  /res:
  /src:

  # All ssets
  /assets:

  # Lua sources
  /app: # Tools
  /scenes: # Scenes, i.e. collections used as proxies
    /intro: # Intro scene
    /driller: # Main Game
    /finalcut: # Final scene

  /main.collection: # Bootstrap collection. It has links to all game collections and content
  /main.script: # Main script of the game.

  # ...
```

### World

1 unit = 1 centimeter (models) = 1 pixels (sprites), and `cube_100.dae` is a 100x100x100cm cube.

### Misc

Debug build for HTML5 using `bob.jar`:
```bash
BOB_SHA1=$(curl -s 'https://d.defold.com/beta/info.json' | jq -r .sha1)
wget --progress=dot:mega -O build/bob.jar "https://d.defold.com/archive/${BOB_SHA1}/bob/bob.jar"
rm -rf build/bundle && mkdir -p build/bundle && java -jar build/bob.jar --email foo@bar.com --auth 12345 --texture-compression true --bundle-output build/bundle/js-web --build-report-html build/bundle/report.html --platform js-web --variant debug --archive distclean resolve build bundle
http-server -c- # npm install http-server -g
```

Download [the latest HTML5 bundle in .zip](https://github.com/aglitchman/defold-ld48-game/archive/refs/heads/gh-pages.zip).

## Credits

Copyright (c) 2021 Artsiom Trubchyk. Licensed under the Apache License, Version 2.0. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

This project is made with [the Defold game engine](https://www.defold.com/) and includes/uses the following deps:
- https://github.com/kikito/tween.lua
- https://github.com/rxi/lume
- https://github.com/britzl/ludobits
- https://github.com/subsoap/defos
- https://github.com/indiesoftby/defold-splitmix64
- https://github.com/indiesoftby/defold-sharp-sprite
- to be filled...

Plus used these content generators:
- Intro/outro planet texture: https://donjon.bin.sh/scifi/world/
- Make it seamless: https://www.imgonline.com.ua/eng/make-seamless-texture.php
