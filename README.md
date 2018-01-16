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

---

# Dev notes

Project was prepared for work in VSCode. Use Haxe Extension Pack.
Main build task targets web.

## Dependencies

- `luxeengine.com` - game engine with renderer and other stuff
- `fast-live-reload` - from NPM, get it globally.

## Haxe Cache servers

Project uses Haxe cache server to both compile the code and provide cod ecompletions while writing.

## Testpage

For some reason running testpage on Windows sucks balls. Run this in proper terminal instead:

```
fast-live-reload --interval 50 -s bin/web/ -sp 8090 -p 8099 src/ -e "flow build web --debug" assets/ -e "flow build web --debug"
```

or for Windows:

```
fast-live-reload --interval 50 -s bin\web\ -sp 8090 -p 8099 src\ -e "flow build web --debug" assets\ -e "flow build web --debug"
```

After running task "Testpage" you'll get:

- testpage hosted at `localhost:8090`
- auto recompilation after you save the file
- testpage auto refresh after the compilation finishes

## Unit testing

Swap haxe configuration in VSCode to `tests.hxml` so completion will work in `test/` files.

```haxe tests.hxml```

Will compile the tests and output into `bin/web/` directory. Make sure you already built the testpage once, so that directory is populated with game files. While the testpage is running, just open `localhost:8090/report.html`.

## Code formatting

Use astyle-extension for VSCode, you'll also need Astyle app on your device.
