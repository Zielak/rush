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

### Haxe Cache servers

There will be 2 haxe cache servers.

1. Created by autocompletion haxe plugin at port `6000`.
2. Created by you, with the task "Haxe Cache Server". Run it before compiling anything.

> TODO: investigate if 2 servers instead of 1 are actually useful. Goal: non blocking completion&compilation.

### Testpage

For some reason running testpage on Windows sucks balls. Run this in proper terminal instead:

```
fast-live-reload --interval 50 -s bin\web\ -sp 8090 src\ -e "flow build web --debug" assets\ -e "flow build web --debug"
```

After running task "Testpage" you'll get:

- testpage hosted at `localhost:8090`
- auto recompilation after you save the file
- testpage auto refresh after the compilation finishes

### Code formatting

Use astyle-extension for VSCode, you'll also need Astyle app on your device.
