
package components;

import luxe.Component;
import luxe.Entity;
import luxe.options.ComponentOptions;
import luxe.Vector;

enum FollowType {
  instant;
  smooth;
}

class Follow extends Component {

  public var lerp:Float = 0.25;

  public var follow_type:FollowType = FollowType.instant;


  public var target:Entity;


  var _v:Vector;

  override public function new (options:FollowOptions) {
    super(options);

    target = options.target;

    if (options.lerp > 0) {
      lerp = options.lerp;
    }

    if (options.follow_type != null) {
      follow_type = options.follow_type;
    }
  }

  override function init() {


  } //ready

  override function update(dt:Float) {
    if (target != null) {
      if (follow_type == instant) {
        entity.pos.x = target.pos.x;
        entity.pos.y = target.pos.y;
      }
      else {
        entity.pos.lerp(target.pos, lerp);
        _v = Vector.Subtract(target.pos, entity.pos);

        if (_v.length < 0.5) {
          entity.pos.x = target.pos.x;
          entity.pos.y = target.pos.y;
        }
      }
    }

  }

}

typedef FollowOptions = {
  > ComponentOptions,

  var target:Entity;

  @:optional var lerp:Float;
  @:optional var follow_type:FollowType;
}
