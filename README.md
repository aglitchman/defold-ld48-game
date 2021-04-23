![Cover](ld48/res/web/loader_cover.png)

# Ludum Dare 48 Game - Made With Defold

This project was created from the "empty" project template. **This is a work-in-progress template for the future LD48.** It will contain a basic setup for camera, screens, preloader, etc.

Play the latest version online - [**Web build**](https://aglitchman.github.io/defold-ld48-game/).

## Structure

```yaml
/ld48: # Main folder

  # C++ sources
  /include:
  /manifests:
  /res:
  /src:

  # Assets
  /assets:

  # Lua sources
  /app: # Tools
  /screens: # Screens, i.e. collections used as proxies
    /testbed:

  /main.collection: # Bootstrap collection. It has links to all game collections and content
  /main.script: # Main script of the game.
```

## Credits

Copyright (c) 2021 Artsiom Trubchyk. Licensed under the Apache License, Version 2.0. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

This project is made with [the Defold game engine](https://www.defold.com/) and includes/uses the following deps:
- OpenGL Mathematics (GLM), a header only C++ mathematics library: https://github.com/g-truc/glm
- LearnOpenGL.com Camera class: https://learnopengl.com/code_viewer_gh.php?code=includes/learnopengl/camera.h
- https://github.com/kikito/tween.lua
- https://github.com/rxi/lume
- to be filled...
