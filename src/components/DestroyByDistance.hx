
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
    timer = Luxe.timer.schedule(0.5, step, true);
  }

  function step() {
    if(entity.destroyed){
      trace('I shouldnt be running!');
      return;
    }
    _v = Vector.Subtract(entity.pos, Luxe.camera.center);

    if (_v.length > distance) {
      // entity.events.fire('destroy.bydistance');
      // trace('${entity.name} destroyed');
      _v = null;
      timer.stop();
      timer = null;
      trace('Destroying!' + this.entity.name);
      entity.destroy();
      entity = null;
    }
  }


}

typedef DestroyByDistanceOptions = {
  > ComponentOptions,

  var distance:Float;
}
