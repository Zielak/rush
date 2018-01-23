import luxe.Entity;
import Action;

using polyfills.ArrayTools;

/**
 *  Sequence is a self-running timeline of actions.
 *  Think of it as a video file. You can play it, stop it,
 *  see it in action etc.
 */

class Sequence extends Entity {

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
  public var current(default, null):Float;
  public function get_current():Float {
    return wholeDuration/currentTime * 100;
  }

  @:isVar public var finished(default, null):Bool = false;

  // List of actions which are blocking progress right now.
  // Listen for them to finish. If there's at least one blocking
  // action, non of the other pending actions should receive an update.
  var blockers:Array<Action>;

  public function new (options:SequenceOptions) {
    super(options);

    name = options.name;
    timeline = populateActions(options.timeline);
    difficulty = options.difficulty;

    // get sequence's duration
    prefix = options.prefix != null ? options.prefix : 0;
    postfix = options.postfix != null ? options.postfix : 0;
    duration = options.duration + prefix + postfix;
  }
  
  function populateActions(actionsDescriptors:Array<ActionDescriptor>):Array<Action> {
    var arr:Array<Action> = [];
    for(desc in actionsDescriptors){
      arr.push(Action.create(desc.options));
    }
    return arr;
  }

  /**
   *  Update the sequence
   *  @param dt - selta time
   *  @return Bool wether this sequence finished or not yet
   */
  override public function update(dt:Float) {

    if (!finished) {
      if (currentTime > wholeDuration) {
        finished = true;
      }
      else if (currentTime >= delay && currentTime <= duration-ending) {
        action.update(dt);

        if (action.finished) {
          next();
        }
      }

      if ((action.wait && !action.fired) || !action.wait) {
        currentTime += dt;
      }

    }

    // actions[current_action].update();
  }

  public function currentActions():Array<Action> {
    return timeline.filter(function(action):Bool{
      // 1. currentTime between its start and end.
      // 2. If end time passed, check if it was even fired (missed short action?)
      return (
        action.start <= current && action.end > current ||
        action.start <= current && action.end <= current && !action.started
      )
    });
  }

  public function reset() {
    finished = false;
    currentTime = 0;

    for (a in timeline) {
      a.reset();
    }
  }

}

typedef SequenceOptions = {
  >luxe.options.EntityOptions,
  var name:String;
  var timeline:Array<ActionDescriptor>;
  var duration:Float;
  var difficulty:Float;

  @:optional var prefix:Float;
  @:optional var postfix:Float;
}

typedef ActionDescriptor = {
  var options:ActionOptions;
  var action:Class<Action>;
}
