# RUSH

Nerve wrecking arcade runner game about `love` and `throwing crates`.

Avoid bombs, grab and throw crates, run, jump and `don’t loose hope`.

Now go! Rush to your love!

| Action     |  |
| :-         | :-:        |
| Movement   | Arrow keys OR `W`,`S`,`A`,`D` |
| Grab crate | jsut walk over them |
| Jump/Dash  | hold move & hit `C` OR `K` |
| START      | Enter or Space |

## Dev notes

Project was prepared for work in VSCode. Use Haxe Extension Pack.
Main build task targets web.

### Dependencies

- `luxeengine.com` - game engine with renderer and other stuff
- `fast-live-reload` - from NPM, get it globally.

### Testpage

After running task "Testpage" you'll get:

- testpage hosted at `localhost:8090`
- auto recompilation after you save the file
- testpage auto refresh after the compilation finishes

You can run testpage manually with:

```fast-live-reload -s bin/web/ -sp 8090 -p 8099 src/ -e "flow build web --debug"```

### Code formatting

Use astyle-extension for VSCode, you'll also need Astyle app on your device.
