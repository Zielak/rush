package sequences;

import phoenix.Vector;
import phoenix.Rectangle;

class Tutorial extends Sequences {
  override public function new() {
    super();

    inline function nice_vector(_x:Float, _y:Float):Vector {
      var v = new Vector(Math.floor(_x), Math.floor(_y));
      v.x = Math.floor(v.x/Tile.TILE_SIZE)*Tile.TILE_SIZE;
      v.y = Math.floor(v.y/Tile.TILE_SIZE)*Tile.TILE_SIZE;

      return v;
    }
    var actions:Array<Action> = new Array<Action>();

    // Speed
    actions.push(new actions.ChangeSpeed({
      target_speed: 0,
      delay: 0,
    }));

    /**
     * WALK OVER CRATE TO GRAB IT
     */
    actions.push(new actions.SpawnCrate({
      pos: nice_vector(Game.width*0.75, Game.height*0.6),
      delay: 2,
    }));

    // Spawn more crates for the hasty people
    for (i in 0...100) {
      actions.push(new actions.SpawnCrate({
        pos: nice_vector(Game.width*0.75, Game.height*0.6),
        delay: 0,
      }));
    }

    actions.push(new actions.ShowTutorialScreen({
      delay: 0.5,
      screen: 'assets/images/text.gif',
      uv: new Rectangle(0, 176, 134, 24),
      pos: new Vector(Game.width/2, 48),
      wait: true,
      wait_event: 'player.grab.crate',
      circle_pos: nice_vector(Game.width*0.75, Game.height*0.5),
      circle_size: 20
    }));

    /**
     * POINT AND CLICK TO THROW IT
     */
    // Spawn bomb first
    actions.push(new actions.SpawnBomb({
      delay: 1.2,
      pos: nice_vector(Game.width*0.25, Game.height*0.3)
    }));
    actions.push(new actions.SpawnBomb({
      delay: 0.2,
      pos: nice_vector(Game.width*0.15, Game.height*0.5)
    }));
    actions.push(new actions.SpawnBomb({
      delay: 0.2,
      pos: nice_vector(Game.width*0.25, Game.height*0.7)
    }));
    actions.push(new actions.ShowTutorialScreen({
      delay: 0,
      screen: 'assets/images/text.gif',
      uv: new Rectangle(0, 200, 106, 24),
      pos: new Vector(Game.width/2, 48),
      wait: true,
      wait_event: 'player.throw.crate',
    }));

    /**
     * JUMP OVER IT, [SPACE]
     */
    actions.push(new actions.SpawnBomb({
      delay: 2,
      pos: nice_vector(Game.width*0.6, Game.height*0.65)
    }));
    actions.push(new actions.ShowTutorialScreen({
      delay: 0.5,
      screen: 'assets/images/text.gif',
      uv: new Rectangle(0, 80, 86, 24),
      pos: new Vector(Game.width/2, 48),
      wait: true,
      wait_event: 'player.dash',
    }));

    // GO GET HER
    actions.push(new actions.CustomAction({
      delay: 3,
      action: function() {
        Luxe.events.fire('hud.show.distance_bar');
      },
    }));
    actions.push(new actions.ShowTutorialScreen({
      delay: 0,
      screen: 'assets/images/text.gif',
      uv: new Rectangle(0, 104, 72, 12),
      pos: new Vector(Game.width/2, 64),
      wait: true,
      wait_input: true,
    }));

    // Speed
    actions.push(new actions.ChangeSpeed({
      target_speed: Game.speed,
      delay: 1.5,
      smooth_time: 2,
    }));


    // Don't loose hope
    actions.push(new actions.CustomAction({
      delay: 3,
      action: function() {
        Luxe.events.fire('hud.show.hope_bar');
      },
    }));
    actions.push(new actions.ShowTutorialScreen({
      delay: 0,
      screen: 'assets/images/text.gif',
      uv: new Rectangle(0, 120, 114, 12),
      pos: new Vector(Game.width/2, 28),
      wait: true,
      wait_input: true,
    }));

    actions.push(new actions.Wait({
      delay: 3,
    }));

    sequences.push(new Sequence({name: 'tutorial', actions: actions, difficulty: 0}));
  }
}