
// import haxe.Constraints;

class Action<T> {

  // @:generic
  public static function create<T>(options:ActionOptions):Action<T> {
    return new Action<T>(options);
  }

  var time:Float = 0;
  public var events:luxe.Events;

  // At which time should this action be fired
  @:isVar public var start(default, null):Float = 0;

  // Action will not finish without an outside bump.
  // Should block the Sequence! HOW?
  @:isVar public var async(default, null):Bool = false;

  // For how long should this action be held playing
  @:isVar public var duration(default, null):Float = 0;

  // Did action fire?
  @:isVar public var fired(default, null):Bool = false;

  // Check if action is completely finished
  @:isVar public var finished(default, null):Bool = false;

  public function new (options:ActionOptions) {
    if(options.start != null) {
      start = options.start;
    }
    if(options.duration != null) {
      duration = options.duration;
    }
  }

  /**
   *  Should be updated everytime a Sequece decides it is time to run.
   *  Never outside of its action time.
   *  @param dt - 
   */
  public function update(dt:Float) {
    if (!fired) {
      return;
    }

    time += dt;

    if (time >= delay) {
      fire();
    }
  }

  function fire() {
    fired = true;
    action();

    if (!async) {
      finish();
    }
  }

  /**
   * Override it do create your own actions
   */
  public function action() {}

  /**
   * Call to reset this action and maybe start over
   */
  public function reset() {
    time = 0;
    finished = false;
    fired = false;
  }

  /**
   * Used when action isn't autoplay (async = true)
   * and we're waiting for the final words
   */
  public function finish() {
    time = 0;
    finished = true;
  }

}

typedef ActionOptions = {
  @:optional var async:Bool;
  @:optional var start:Float;
  @:optional var duration:Float;
  @:optional var wait:Bool;
}
