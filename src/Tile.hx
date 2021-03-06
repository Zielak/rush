
import components.DestroyByDistance;
import luxe.Sprite;
import luxe.options.SpriteOptions;
import luxe.Vector;

class Tile extends Sprite {

  public static inline var TILE_SIZE:Float = 16;
  public static inline var TILES_COUNT:Int = 32;

  var tile_id:Int = -1;
  // var tiles_x:Int;
  // var tiles_y:Int;

  override public function ondestroy() {
    if (this.geometry != null) {
      this.geometry.drop();
    }
    super.ondestroy();
  }

  override public function new (options:TileOptions) {
    options.name_unique = true;
    options.name = 'tile';
    options.centered = true;
    options.texture = Luxe.resources.texture('assets/images/tiles.gif');
    options.texture.filter_mag = nearest;
    options.texture.filter_min = nearest;
    options.size = new Vector(TILE_SIZE, TILE_SIZE);
    options.depth = 0;


    super(options);

    // if (Math.round(Math.random()) > 0) {
    //   this.rotation_z = 90;
    //   this.origin.y -= 1;
    // }
    this.rotation_z = Math.round(Math.random()*360/90)*90;
    // this.rotation_z = Math.random()*360;

    if (options.tile_id != null) {
      tile_id = options.tile_id;
    }

    // tiles_x = Math.floor(options.texture.width / TILE_SIZE);
    // tiles_y = Math.floor(options.texture.height / TILE_SIZE);
  }




  override function init() {

    // events.listen('movement.killBounds', function(){
    //     Luxe.events.fire('tile.outofbounds');
    // });

    if (tile_id == -1) {
      tile_id = Math.floor(Math.random()*TILES_COUNT);
    }

    this.uv.w = TILE_SIZE;
    this.uv.h = TILE_SIZE;

    this.uv.x = tile_id * TILE_SIZE;
    this.uv.y = TILE_SIZE;

    add(new DestroyByDistance({
      name: 'tile',
      distance: 160,
    }));
  }

}



typedef TileOptions = {
  > SpriteOptions,

  @:optional var tile_id:Int;
}

