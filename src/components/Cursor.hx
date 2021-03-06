
package components;

import luxe.Component;
import luxe.options.ComponentOptions;
import luxe.Input;
import luxe.Sprite;
import luxe.Vector;
import phoenix.Batcher;

class Cursor extends Component {

  var sprite:Sprite;

  var batcher:Batcher;
  var depth:Float;

  // Mouse position
  var mouse_pos:Vector;


  override public function new (options:CursorOptions) {
    super(options);
    batcher = options.batcher;
    depth = options.depth;

  }

  override function onadded() {
    mouse_pos = new Vector();

    sprite = new Sprite({
      centered: true,
      size: new Vector(21, 21),
      texture: Luxe.resources.texture('assets/images/cursor.gif'),
      depth: depth,
      batcher: batcher,
    });
    sprite.texture.filter_mag = sprite.texture.filter_min = nearest;
  }

  override function onremoved() {
    sprite.destroy();
    sprite = null;
    mouse_pos = null;
  }

  override function update(dt:Float) {
    mouse_pos.copy_from(Luxe.screen.cursor.pos);
    sprite.pos.copy_from(mouse_pos);
    sprite.pos.divideScalar(Luxe.camera.zoom);
    sprite.pos.x = Math.floor(sprite.pos.x);
    sprite.pos.y = Math.floor(sprite.pos.y);
  }

  // Let's see how it goes...
  // override function onmousemove(e:MouseEvent)
  // {
  //     mouse_pos.copy_from( e.pos );
  //     sprite.pos.copy_from( mouse_pos );
  //     sprite.pos.x = HUD.roundPixels(sprite.pos.x);
  //     sprite.pos.y = HUD.roundPixels(sprite.pos.y);
  // }

}

typedef CursorOptions = {
  > ComponentOptions,

  var batcher:Batcher;
  var depth:Float;
}
