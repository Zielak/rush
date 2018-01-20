package debug;

import luxe.Entity;
import luxe.Input;
import luxe.Text;
import phoenix.Vector;

class KeyListener extends Entity {

  var keyGroups:Array<DebugGroup>;
  var keyActions:Array<DebugAction>;

  var currentGroup:DebugGroup;
  var nextPossibleStrokes:Array<DebugAction>;

  var text:Text;

  override public function new (options:Dynamic) {
    super(options);

    // TODO: maybe object struct? instead of 2 arrays...
    keyGroups = new Array<DebugGroup>();
    keyActions = new Array<DebugAction>();

    keyGroups.push({
      name: rendering,
      keys: { key: Key.key_r, mod: [shift] },
      event: 'rendering',
    });
    keyGroups.push({
      name: player,
      keys: { key: Key.key_p, mod: [shift] },
      event: 'player',
    });
    keyGroups.push({
      name: sequence,
      keys: { key: Key.key_s, mod: [shift] },
      event: 'sequence',
    });
    keyGroups.push({
      name: game,
      keys: { key: Key.key_g, mod: [shift] },
      event: 'game',
    });

    // Game
    keyActions.push({
      group: game,
      name: 'Pause/resume',
      keys: { key: Key.key_p },
      event: 'pause'
    });
    keyActions.push({
      group: game,
      name: 'Hope max',
      keys: { key: Key.key_h },
      event: 'hope.max'
    });

    // Sequence
    keyActions.push({
      group: sequence,
      name: 'Force Finish',
      keys: { key: Key.key_f },
      event: 'finish'
    });
    keyActions.push({
      group: sequence,
      name: 'Pick next',
      keys: { key: Key.key_n },
      event: 'next'
    });

    // Rendering
    keyActions.push({
      group: rendering,
      name: 'Shader toggle',
      keys: { key: Key.key_s },
      event: 'shader.toggle'
    });

    // Player
    keyActions.push({
      group: player,
      name: 'Animations toggle',
      keys: { key: Key.key_a },
      event: 'animations.toggle'
    });
    keyActions.push({
      group: player,
      name: 'Input toggle',
      keys: { key: Key.key_i },
      event: 'input.toggle',
    });
    keyActions.push({
      group: player,
      name: 'Player on mouse',
      keys: { key: Key.key_m },
      event: 'mouse.follow',
    });

    initText();
  }

  function initText() {
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
    var currentStroke:KeyCombo = {
      key: event.keycode,
      mod: getKeyMods(event.mod)
    }

    // trace('text should have: ' + keyComboToString(currentStroke));
    // trace(currentStroke);
    text.text = keyComboToString(currentStroke);

    // Try to get a current group from the key combination
    if (currentGroup == null) {
      currentGroup = getGroupByKeys(currentStroke);
      if (currentGroup != null) {
        // trace(keyComboToString(currentStroke));
        // trace('remembering current group: '+currentGroup.name.getName());
      }
    }
    else {
      // Find current strokes in current group
      var currentAction:DebugAction = getActionFromGroup(currentGroup, currentStroke);
      // trace(keyComboToString(currentStroke));
      if (currentAction != null) {
        fire(currentAction);
        currentGroup = null;
      }
      else {
        currentGroup = null;
        // trace('no match, forgetting group.');
      }
    }
  }

  function fire(action:DebugAction):Void {
    if (!validateAction(action)) {
      return;
    }
    var strings:Array<String> = (action.events != null && action.events.length > 0) ? action.events.copy() : [];
    if (action.event != null) {
      strings.push(action.event);
    }
    var groupEvent:String = getGroupName(action.group).event;
    var eventString:String;

    for (s in strings) {
      eventString = 'debug_'+groupEvent+'.'+s;
      trace('FIRE: ' + eventString);
      Luxe.events.fire(eventString);
    }
  }

  function validateAction(action:DebugAction):Bool {
    // has one of those `event` or `events`
    if (action.event == null && action.events == null) {
      throw 'action `${action.name}` must have either `event` or `events`';
      return false;
    }
    if (action.event == null && action.events != null && action.events.length == 0) {
      throw 'action `${action.name}` must have at least one string in `events` array';
      return false;
    }

    return true;
  }

  function getGroupName(name:DebugGroupName):DebugGroup {
    for (group in keyGroups) {
      if (group.name == name) {
        return group;
      }
    }
    return null;
  }

  function getActionByGroup(group:DebugGroupName):Array<DebugAction> {
    var actions:Array<DebugAction> = [];

    for (a in keyActions) {
      if (a.group == group) {
        actions.push(a);
      }
    }

    return actions;
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

  function getActionFromGroup(group:DebugGroup, keys:KeyCombo):DebugAction {
    for (action in keyActions) {
      if (action.group != group.name) {
        continue;
      }
      if (!compareKeyCombo(keys, action.keys)) {
        continue;
      }
      else {
        return action;
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
    // If any don't have `mod`, add just empty array
    if (a.mod == null) {
      a.mod = [];
    }
    if (b.mod == null) {
      b.mod = [];
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

    // mod.lshift ? arr.push(lshift) : null;
    // mod.rshift ? arr.push(rshift) : null;
    // mod.lctrl ? arr.push(lctrl) : null;
    // mod.rctrl ? arr.push(rctrl) : null;
    // mod.lalt ? arr.push(lalt) : null;
    // mod.ralt ? arr.push(ralt) : null;
    // mod.lmeta ? arr.push(lmeta) : null;
    // mod.rmeta ? arr.push(rmeta) : null;
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
    for (mod in keys.mod) {
      mods += mod.getName() + ' ';
    }
    // if(keys.key == keys.mod[0]){
    //   return mods;
    // }else{
    return mods + Key.name(keys.key);
    // }
  }

}

enum DebugGroupName {
  game;
  player;
  sequence;
  rendering;
}

typedef DebugGroup = {
  name:DebugGroupName,
  keys:KeyCombo,
  event:String,
}

typedef DebugAction = {
  group:DebugGroupName,
  name:String,
  keys:KeyCombo,
  ?event:String,
  ?events:Array<String>,
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
