import luxe.Entity;
import luxe.Input;
import luxe.Text;
import phoenix.Vector;

class Debugger extends Entity {

  var keyGroups:Array<DebugGroup>;
  var keyMap:Array<KeySequence>;

  var lastStroke:KeyCombo;
  var currentGroup:DebugGroup;
  var nextPossibleStrokes:Array<KeySequence>;

  var text:Text;

  override public function new (options:Dynamic) {
    super(options);
    trace('HELLO?');

    lastStroke = null;

    keyGroups = new Array<DebugGroup>();
    keyMap = new Array<KeySequence>();

    keyGroups.push({
      name: rendering,
      keys: { key: Key.key_s, mod: [lshift] },
      event: 'rendering',
    });
    keyGroups.push({
      name: player,
      keys: { key: Key.key_p, mod: [lshift] },
      event: 'player',
    });
    keyGroups.push({
      name: sequence,
      keys: { key: Key.key_s, mod: [lshift] },
      event: 'sequence',
    });


    // Rendering
    keyMap.push({
      group: rendering,
      name: 'Shader toggle',
      keys: [],
      event: 'shader.toggle'
    });

    // Player
    keyMap.push({
      group: player,
      name: 'Animations toggle',
      keys: [],
      event: 'animations.toggle'
    });

    initText();
  }

  function initText(){
    var hud_batcher = null;
    for (b in Luxe.renderer.batchers) {
      if (b.name == 'hud_batcher') {
        hud_batcher = b;
      }
    }
    text = new Text({
      point_size: 20,
      text: 'Debugger!',
      pos: new Vector(Game.width/2, Game.height/2),
      batcher: hud_batcher,
      depth: 20
    });
  }

  override public function onkeydown(event:KeyEvent) {
    trace('KEYDOWN');
    var currentStroke:KeyCombo = {
      key: event.keycode,
      mod: getKeyMods(event.mod)
    }

    trace('text should have: '+keyComboToString(currentStroke));
    text.text = keyComboToString(currentStroke);

    // Had something previously?
    if (lastStroke != null) {

    } else {
      currentGroup = getGroupByKeys(currentStroke);
      if(currentGroup == null){
        return;
      }
      // Remember next possible strokes
      // nextPossibleStrokes = 

      lastStroke = currentGroup.keys;
    }

  }

  function getGroupByKeys(keys:KeyCombo):DebugGroup {
    for (group in keyGroups) {
      if (!compareKeyCombo(keys, group.keys)) {
        continue;
      }
      else {
        return group;
      }
    }
    return null;
  }

  /**
   *  Compare if both key combos match
   *  @param a -
   *  @param b -
   *  @return Bool true if both combos are the same
   */
  function compareKeyCombo(a:KeyCombo, b:KeyCombo):Bool {
    // Compare keys
    if (a.key != b.key) {
      return false;
    }
    // Compare number of modifiers
    if (a.mod.length != b.mod.length) {
      return false;
    }
    // Compare mod arrays
    var matchCount:Int = 0;

    for (aMod in a.mod) {
      // for each mod key in A
      if (b.mod.indexOf(aMod) >= 0) {
        matchCount++;
      }
    }

    if (matchCount != a.mod.length) {
      return false;
    }
    else {
      return true;
    }
  }

  /**
   *  Convert luxe's ModState into our array of modifier keys
   *  @param mod -
   *  @return Array<KeyMods>
   */
  function getKeyMods(mod:ModState):Array<KeyMods> {
    var arr = new Array<KeyMods>();

    mod.lshift ? arr.push(lshift) : null;
    mod.rshift ? arr.push(rshift) : null;
    mod.lctrl ? arr.push(lctrl) : null;
    mod.rctrl ? arr.push(rctrl) : null;
    mod.lalt ? arr.push(lalt) : null;
    mod.ralt ? arr.push(ralt) : null;
    mod.lmeta ? arr.push(lmeta) : null;
    mod.rmeta ? arr.push(rmeta) : null;
    mod.num ? arr.push(num) : null;
    mod.caps ? arr.push(caps) : null;
    mod.mode ? arr.push(mode) : null;
    mod.ctrl ? arr.push(ctrl) : null;
    mod.shift ? arr.push(shift) : null;
    mod.alt ? arr.push(alt) : null;
    mod.meta ? arr.push(meta) : null;

    return arr;
  }

  function keyComboToString(keys:KeyCombo):String {
    var mods:String = '';
    for(mod in keys.mod) {
      mods += mod.getName() + '';
    }
    return mods + Std.string(keys.key);
  }

}

enum DebugGroupName {
  player;
  sequence;
  rendering;
}

typedef DebugGroup = {
  name:DebugGroupName,
  keys:KeyCombo,
  event:String,
}

typedef KeySequence = {
  group:DebugGroupName,
  name:String,
  keys:Array<KeyCombo>,
  event:String,
}

typedef KeyCombo = {
  key:Int,
  ?mod:Array<KeyMods>,
}

enum KeyMods {
  lshift;
  rshift;
  lctrl;
  rctrl;
  lalt;
  ralt;
  lmeta;
  rmeta;
  num;
  caps;
  mode;
  ctrl;
  shift;
  alt;
  meta;
}
