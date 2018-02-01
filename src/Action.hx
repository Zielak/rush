
// import haxe.Constraints;

class Action {

  var currentTime:Float = 0;
  public var events:luxe.Events;

  // At which time should this action be fired
  @:isVar public var start(default, null):Float = 0;

  // For how long should this action be held playing
  @:isVar public var duration(default, null):Float = 0;

  public var end(default, null):Float;
  public function get_end():Float {
    return start + duration;
  }

  // Action will not finish without an outside bump.
  // Action should still play and keep updating untill `currentTime`
  // reaches `duration` value.
  @:isVar public var async(default, null):Bool = false;

  // Did action fire?
  @:isVar public var fired(default, null):Bool = false;

  // Check if action is completely finished
  @:isVar public var finished(default, null):Bool = false;

  public function new (?options:ActionOptions) {
    if (options.start != null) {
      start = options.start;
    }
    if (options.duration != null) {
      duration = options.duration;
    }
  }

  /**
   *  Should be updated everytime a Sequece decides it is time to run.
   *  Never outside of its action time.
   *  @param dt -
   */
  public function update(dt:Float) {
    if (!fired && !finished) {
      fire();
    }

    if(!async && !finished){
      currentTime += dt;
    }

    if (currentTime >= duration) {
      if (!async) {
        finish();
      } else {
        // I should keep waiting...
      }
    }
  }

  function fire() {
    fired = true;
    onStart();
  }

  /**
   * Call to reset this action and maybe start over
   */
  public function reset() {
    currentTime = 0;
    finished = false;
    fired = false;
  }

  /**
   * Used when action isn't autoplay (async = true)
   * and we're waiting for the final words
   */
  public function finish() {
    currentTime = 0;
    finished = true;
    onFinish();
  }

  /**
   * Override it to create your own starting action
   */
  public function onStart() {}

  /**
   * Override it to handle each update
   */
  public function onUpdate(dt:Float) {}

  /**
   * Override it to create your own starting action
   */
  public function onFinish() {}


}

typedef ActionOptions = {
  @:optional var async:Bool;
  @:optional var start:Float;
  @:optional var duration:Float;
}

typedef ActionDescriptor<T> = {
  @:optional var options:T;
  var action:Class<Action>;
}
