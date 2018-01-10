
package components;

import luxe.Component;
import luxe.options.ComponentOptions;
import luxe.Rectangle;

import luxe.Sprite;
import luxe.Vector;
import snow.api.Timer;

class DestroyByDistance extends Component {

  public var distance:Float;
  var _dist:Float;

  var timer:Timer;

  var _v:Vector;

  override public function new (options:DestroyByDistanceOptions) {
    options.name = (options.name == null) ? options.name + 'Distance' : 'distance';
    super(options);

    distance = options.distance;
    timer = Luxe.timer.schedule(1, step, true);
  }

  override public function ondestroy() {
    timer.stop();
    timer = null;
    _v = null;
  }

  function step() {
    _v = Vector.Subtract(entity.pos, Luxe.camera.center);

    if (_v.length > distance) {
      // entity.events.fire('destroy.bydistance');
      // trace('${entity.name} destroyed');
      timer.stop();
      trace('Destroying!' + this.entity.name);
      entity.destroy();
    }
  }

}

typedef DestroyByDistanceOptions = {
  > ComponentOptions,

  var distance:Float;
}
