import Action;

// using polyfills.ArrayTools;

/**
 *  Sequence is a self-running timeline of actions.
 *  Think of it as a video file. You can play it, stop it,
 *  see it in action etc.
 */

class Sequence {

  public var name:String;

  @:isVar public var timeline(default, null):Array<Action>;

  @:isVar public var difficulty(default, null):Float;

  // Initial delay before this sequence is run
  @:isVar public var prefix(default, null):Float;
  // Delay right before the ending of this sequence
  @:isVar public var postfix(default, null):Float;
  // Duration of the whole sequence (excluding pre and postfix)
  @:isVar public var duration(default, null):Float;
  // Duration + prefix + postfix
  public var wholeDuration(default, null):Float;
  public function get_wholeDuration():Float {
    return duration + prefix + postfix;
  }

  // Current time in seconds
  @:isVar public var currentTime(default, null):Float = 0;
  // Time, but in percent 0-1.0
  public var current(get, null):Float;
  public function get_current():Float {
    return wholeDuration/currentTime * 100;
  }

  var currentActions(get, null):Array<Action>;
  function get_currentActions():Array<Action> {
    return timeline.filter(function(action):Bool{
      // 1. currentTime between its start and end.
      // 2. If end time passed, check if it was even fired (missed short action?)
      return (
        action.start <= current && action.end > current ||
        action.start <= current && action.end <= current && !action.fired
      );
    });
  }

  @:isVar public var finished(default, null):Bool = false;

  // List of actions which are blocking progress right now.
  // Listen for them to finish. If there's at least one blocking
  // action, non of the other pending actions should receive an update.
  var blockers:Array<Action>;

  public function new (options:SequenceOptions) {
    name = options.name;
    timeline = populateActions(options.timeline);
    difficulty = options.difficulty;

    // get sequence's duration
    prefix = options.prefix != null ? options.prefix : 0;
    postfix = options.postfix != null ? options.postfix : 0;

    // calculate duration
    duration = calculateDuration(timeline);

    blockers = [];
  }

  function initEvents() {
    for (action in timeline) {
      action.events.listen('started', function(action:Action) {

      });
      action.events.listen('finished', function(action:Action) {
        blockers = blockers.filter(function(element:Action) {
          return element != action;
        });
      });
      action.events.listen('waiting', function(action:Action) {
        blockers.push(action);
      });
    }
  }

  function clearEvents() {
    // TODO:
  }

  public function enable() {
    initEvents();
  }

  public function disable() {
    clearEvents();
  }

  /**
   *  Update the sequence
   *  @param dt - selta time
   *  @return Bool wether this sequence finished or not yet
   */
  public function update(dt:Float) {

    if (!finished && currentTime > wholeDuration) {
      finished = true;
    }

    if (finished) {

    }
    else {
      // Update every running action
      for (a in currentActions) {
        a.update(dt);
      }
      if (blockers.length == 0) {
        currentTime += dt;
      }
    }

    // actions[current_action].update();
  }

  public function reset() {
    finished = false;
    currentTime = 0;

    for (a in timeline) {
      a.reset();
    }
  }

  /**
   *  Only for debugging i guess
   */
  public function _finish() {
    finished = true;
  }

  // STATIC

  public static function populateActions(actionsDescriptors:Array<ActionDescriptor>):Array<Action> {
    var arr:Array<Action> = actionsDescriptors.map(function(desc:ActionDescriptor) {
      // return new desc.action(desc.options);
      return Type.createInstance(desc.action, [desc.options]);
    });
    // for(desc in actionsDescriptors){
    //   var action = Type.createInstance();
    //   arr.push(action);
    // }
    return arr;
  }

  public static function calculateDuration(timeline:Array<Action>):Float {
    var length:Float = 0;
    for (a in timeline) {
      if (a.start + a.duration > length) {
        length = a.start + a.duration;
      }
    }
    return length;
  }

}

typedef SequenceOptions = {
  > luxe.options.EntityOptions,
  var name:String;
  var timeline:Array<ActionDescriptor>;
  @:optional var duration:Float;
  var difficulty:Float;

  @:optional var prefix:Float;
  @:optional var postfix:Float;
}
