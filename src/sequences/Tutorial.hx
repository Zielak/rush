package sequences;

import phoenix.Vector;
import phoenix.Rectangle;

import Action;

class Tutorial extends Sequences {
  override public function new(?options:luxe.options.EntityOptions) {
    super(options);

    inline function nice_vector(_x:Float, _y:Float):Vector {
      var v = new Vector(Math.floor(_x), Math.floor(_y));
      v.x = Math.floor(v.x/Tile.TILE_SIZE)*Tile.TILE_SIZE;
      v.y = Math.floor(v.y/Tile.TILE_SIZE)*Tile.TILE_SIZE;

      return v;
    }
    var timeline:Array<ActionDescriptor> = [];

    // Speed
    timeline.push({ action: actions.ChangeSpeed, options: {
      target_speed: 0,
      prefix: 0,
    }});

    /**
     * WALK OVER CRATE TO GRAB IT
     */
    timeline.push({ action: actions.SpawnCrate, options: {
      pos: nice_vector(Game.width*0.75, Game.height*0.6),
      prefix: 2,
    }});

    // Spawn more crates for the hasty people
    for (i in 0...50) {
      timeline.push({ action: actions.SpawnCrate, options: {
        pos: nice_vector(Game.width*0.75, Game.height*0.6),
        prefix: 0,
      }});
    }

    timeline.push({ action: actions.ShowTutorialScreen, options: {
      prefix: 0.5,
      screen: 'assets/images/text.gif',
      uv: new Rectangle(0, 176, 134, 24),
      pos: new Vector(Game.width/2, 48),
      async: true,
      wait_event: 'player.grab.crate',
      circle_pos: nice_vector(Game.width*0.75, Game.height*0.5),
      circle_size: 20
    }});

    /**
     * POINT AND CLICK TO THROW IT
     */
    // Spawn bomb first
    timeline.push({ action: actions.SpawnBomb, options: {
      prefix: 1.2,
      pos: nice_vector(Game.width*0.25, Game.height*0.3)
    }});
    timeline.push({ action: actions.SpawnBomb, options: {
      prefix: 0.2,
      pos: nice_vector(Game.width*0.15, Game.height*0.5)
    }});
    timeline.push({ action: actions.SpawnBomb, options: {
      prefix: 0.2,
      pos: nice_vector(Game.width*0.25, Game.height*0.7)
    }});
    timeline.push({ action: actions.ShowTutorialScreen, options: {
      prefix: 0,
      screen: 'assets/images/text.gif',
      uv: new Rectangle(0, 200, 106, 24),
      pos: new Vector(Game.width/2, 48),
      async: true,
      wait_event: 'player.throw.crate',
    }});

    /**
     * JUMP OVER IT, [SPACE]
     */
    timeline.push({ action: actions.SpawnBomb, options: {
      prefix: 2,
      pos: nice_vector(Game.width*0.6, Game.height*0.65)
    }});
    timeline.push({ action: actions.ShowTutorialScreen, options: {
      prefix: 0.5,
      screen: 'assets/images/text.gif',
      uv: new Rectangle(0, 80, 86, 24),
      pos: new Vector(Game.width/2, 48),
      async: true,
      wait_event: 'player.dash',
    }});

    // GO GET HER
    timeline.push({ action: actions.CustomAction, options: {
      prefix: 3,
      action: function() {
        Luxe.events.fire('hud.show.distance_bar');
      },
    }});
    timeline.push({ action: actions.ShowTutorialScreen, options: {
      prefix: 0,
      screen: 'assets/images/text.gif',
      uv: new Rectangle(0, 104, 72, 12),
      pos: new Vector(Game.width/2, 64),
      async: true,
      wait_input: true,
    }});

    // Speed
    timeline.push({ action: actions.ChangeSpeed, options: {
      target_speed: Game.speed,
      prefix: 1.5,
      smooth_time: 2,
    }});


    // Don't loose hope
    timeline.push({ action: actions.CustomAction, options: {
      prefix: 3,
      action: function() {
        Luxe.events.fire('hud.show.hope_bar');
      },
    }});
    timeline.push({ action: actions.ShowTutorialScreen, options: {
      prefix: 0,
      screen: 'assets/images/text.gif',
      uv: new Rectangle(0, 120, 114, 12),
      pos: new Vector(Game.width/2, 28),
      async: true,
      wait_input: true,
    }});

    timeline.push({
      action: actions.CustomAction,
      options: {
        prefix: 3,
        action: function() {
          Luxe.events.fire('tutorial.finished');
        }
      }
    });

    sequences.push(new Sequence({name: 'tutorial', timeline: timeline, difficulty: 0}));
  }
}