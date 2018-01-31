
import components.Blinking;
import components.Movement;
import enemies.Crate;
import luxe.Color;
import luxe.Entity;
import luxe.Rectangle;
import luxe.tween.Actuate;
import luxe.Vector;
import luxe.Visual;
import Action;

class Spawner extends Entity {

  var tilespawn_density:Float = 1;
  var tilespawn_density_max:Float = 1; // 0.65;

  var sequences:Sequences;

  var gameover_seq:Sequence;

  var time:Float = 0;
  var crate_cd:Float = 0;
  var crate_max_cd:Float = 2;


  /**
   * Everyone can pick a place to spawn
   * @return Vector some point out of camera's sight
   */
  static public function pick_place(spawnPlace:SpawnPlace, random:Bool = true):Vector {
    var _x:Float = Luxe.camera.center.x;
    var _y:Float = Luxe.camera.center.y;

    // Pick random place in front of camera's center
    var s:Float = 0.9;

    if (random) {
      if (spawnPlace == front
          || spawnPlace == back) {
        if (Game.direction == left || Game.direction == right) {
          _y += -Game.height*s/2 + Game.random.float(0, Game.height*s);
        }

        if (Game.direction == up || Game.direction == down) {
          _x += -Game.width*s/2 + Game.random.float(0, Game.width*s);
        }
      }
    }

    // if(Game.direction == left || Game.direction == right){
    //     _y += -Game.height*s/2 + Game.random.float(0, Game.height*s);
    // }
    // if(Game.direction == up || Game.direction == down){
    //     _x += -Game.width*s/2 + Game.random.float(0, Game.width*s);
    // }

    if (spawnPlace == front) {
      switch (Game.direction) {
        case right: _x += Game.width/2 + Tile.TILE_SIZE;
        case down: _y += Game.height/2 + Tile.TILE_SIZE;
        case left: _x -= Game.width/2 + Tile.TILE_SIZE;
        case up: _y -= Game.height/2 + Tile.TILE_SIZE;
      }
    }
    else if (spawnPlace == back) {
      switch (Game.direction) {
        case right: _x -= Game.width/2 + Tile.TILE_SIZE*2;
        case down: _y -= Game.height/2 + Tile.TILE_SIZE*2;
        case left: _x += Game.width/2 + Tile.TILE_SIZE*2;
        case up: _y += Game.height/2 + Tile.TILE_SIZE*2;
      }
    }
    else if (spawnPlace == left) {
      switch (Game.direction) {
        case left:_x += Game.width/2 + Tile.TILE_SIZE;
        case up:_y += Game.height/2 + Tile.TILE_SIZE;
        case right:_x -= Game.width/2 - Tile.TILE_SIZE;
        case down:_y -= Game.height/2 - Tile.TILE_SIZE;
      }
    }

    // Round up the position
    _x = Math.round(_x/16)*16;
    _y = Math.round(_y/16)*16;

    return new Vector(_x, _y);
  }

  override function init() {
    trace('SPAWNER: init');
    time = 0;
    next_crate_cd();
    tilespawn_density = 1;

    init_events();
    init_sequences();

    spam_tiles();
  }

  function init_events() {
    Luxe.events.listen('spawn.tilescolrow', function(_) {
      spawn_tiles();
    });

    Luxe.events.listen('spawn.puff', function(e:SpawnEvent) {
      var p:Puff = new Puff({pos:e.pos.clone()});

      if (e.depth != null) {
        p.depth = e.depth;
      }

      var _v:Vector = null;

      if (e.velocity != null) {
        _v = e.velocity.clone();
      }
      else if (e.velocity == null && e.speed != null) {
        _v = new Vector(e.speed, 0);
        _v.angle2D = e.angle;
      }

      if (_v != null) {
        p.add(new Movement({velocity:_v}));
      }

      p.add(new Blinking({
        time_on: Math.random()*0.5 + 0.2,
        time_off: Math.random()*0.3 + 0.1,
      }));

    });

    Luxe.events.listen('spawn.flash', function(e:SpawnEvent) {
      var flash:Visual = new Visual({
        pos: e.pos.clone(),
        geometry: Luxe.draw.circle({
          x:0, y:0,
          r: 20,
          color: new Color(1, 1, 1, 1),
        }),
        depth: 12
      });
      flash.add(new components.DestroyByTime({time:0.1}));

    });

    Luxe.events.listen('player.hit.enemy', function(_) {
      var _arr:Array<Entity> = new Array<Entity>();
      Luxe.scene.get_named_like('tile', _arr);
      var _v:Vector = Game.directional_vector();

      // _v.angle2D += Math.PI;
      _v.length = 750;

      for (t in _arr) {
        if (Math.random() > 0.5) {
          t.add(new components.Movement({velocity: _v}));
        }
      }

      tilespawn_density = 0.25;
      spam_tiles();
    });

    Luxe.events.listen('game.over.hope', function(_) {
      init_game_over_sequences('hope');
    });
    Luxe.events.listen('game.over.distance', function(_) {
      init_game_over_sequences('distance');
    });

    this.events.listen('sequence.gal', function(_) {
      init_gal_sequences();
    });
  }

  function init_sequences() {
    if (!Game.tutorial) {
      Actuate.tween(Game, 2, {speed:Game.speed});
      sequences = new sequences.World1();
    }
    else {
      sequences = new sequences.Tutorial();
    }
    sequences.pickSequence();
  }

  function finish_tutorial() {
    Game.tutorial = false;

    Luxe.events.fire('tutorial.finished');

    init_sequences();
  }


  function init_game_over_sequences(reason:String) {
    trace('init_game_over_sequences');
    var arr:Array<Entity> = new Array<Entity>();
    arr = Game.scene.get_named_like('cruncher', arr);

    for (e in arr) {
      e.destroy();
    }

    arr = Game.scene.get_named_like('bomb', arr);

    for (e in arr) {
      e.destroy();
    }

    arr = null;

    var timeline:Array<ActionDescriptor> = new Array<ActionDescriptor>();

    // Speed
    // TODO: whoops, options must be of type ChangeSpeedOptions, but expects ActionOptions...
    timeline.push({ action: actions.ChangeSpeed, options: {
      target_speed: 0
    });

    if (reason == 'hope') {
      timeline.push(new actions.ShowTutorialScreen({
        delay: 0.5,
        screen: 'assets/images/text.gif',
        uv: new Rectangle(0, 24, 108, 24),
        pos: new Vector(Game.width/2, 40),
        wait: true,
        wait_input: true,
      }));

    }

    else if (reason == 'distance') {
      timeline.push(new actions.ShowTutorialScreen({
        delay: 0.5,
        screen: 'assets/images/text.gif',
        uv: new Rectangle(0, 0, 86, 24),
        pos: new Vector(Game.width/2, 40),
        wait: true,
        wait_input: true,
      }));

    }

    timeline.push(new actions.CustomAction({
      delay: 1,
      action: function() {
        Luxe.events.fire('game.over.quit');
      }
    }));

    gameover_seq = new Sequence({name:'game over', timeline: timeline, difficulty: -1});

  }



  function init_gal_sequences() {
    trace('init_gal_sequences');

    var actions:Array<Action> = new Array<Action>();

    // It's nice to see you
    actions.push(new actions.ShowTutorialScreen({
      delay: 4,
      screen: 'assets/images/text.gif',
      uv: new Rectangle(0, 144, 72, 24),
      pos: new Vector(Game.width/2, 40),
      wait: true,
      wait_input: true,
    }));


    actions.push(new actions.CustomAction({
      delay: 1,
      action: function() {
        Luxe.events.fire('game.over.quit');
      }
    }));

    gameover_seq = new Sequence({name:'game over gal', actions: actions, difficulty: -1});

  }


  override function update(dt:Float) {
    if (Game.playing && !Game.delayed && !Game.tutorial) {
      time += dt;
      crate_cd -= dt;

      if (tilespawn_density < tilespawn_density_max) {
        tilespawn_density += dt/18;
      }

      if (crate_cd <= 0) {
        spawn_crate();
      }

      if (sequences.length > 0) {
        if (sequences.update(dt)) {
          sequences.pickSequence();
        }
      }
    }

    if (Game.tutorial) {
      if (tilespawn_density < tilespawn_density_max) {
        tilespawn_density += dt/20;
      }
      if (sequences.update(dt)) {
        finish_tutorial();
      }
    }

    if (!Game.playing && Game.gameover) {
      if (gameover_seq==null) {

      }
      else if (gameover_seq.update(dt)) {
        trace('gonna fire event');
        Luxe.events.fire('game.over.quit');
        gameover_seq == null;
      }
    }
  }

  /**
   * Populates the screen with new tiles. Probably one time use
   */
  function spam_tiles() {
    var _x:Float = 0;
    var _y:Float = 0;

    var x0:Int = -Math.floor(Game.width / Tile.TILE_SIZE / 2);
    var y0:Int = -Math.floor(Game.height / Tile.TILE_SIZE / 2);
    var xm:Int = Math.floor(Game.width / Tile.TILE_SIZE) + 2;
    var ym:Int = Math.floor(Game.height / Tile.TILE_SIZE) + 2;

    for (x in x0...xm) {
      for (y in y0...ym) {
        if (Math.random() > tilespawn_density) {
          continue;
        }

        _x = Luxe.camera.center.x + x * Tile.TILE_SIZE;
        _y = Luxe.camera.center.y + y * Tile.TILE_SIZE;

        new Tile({
          pos: new Vector(_x, _y),
        });
      }
    }
  }


  /**
   * Spawns row or column of tile after camera has moved TILE_SIZE px.
   */
  function spawn_tiles() {
    // trace('spawn tiles');

    var col:Bool = false;
    var count:Int;

    var _x:Float;
    var _y:Float;

    switch (Game.direction) {
      case right:
        col = true;
        count = Math.ceil(Game.height / Tile.TILE_SIZE);
      case down:
        col = false;
        count = Math.ceil(Game.width / Tile.TILE_SIZE);
      case left:
        col = true;
        count = Math.ceil(Game.height / Tile.TILE_SIZE);
      case up:
        col = false;
        count = Math.ceil(Game.width / Tile.TILE_SIZE);
    }


    for (i in -2...count+2) {
      if (Math.random() > tilespawn_density) {
        continue;
      }

      if (col) {
        if (Game.direction == left) {
          _x = Luxe.camera.center.x - Game.width/2 - Tile.TILE_SIZE*2;
        }
        else {
          _x = Luxe.camera.center.x + Game.width/2 + Tile.TILE_SIZE*2;
        }

        _y = Luxe.camera.center.y - Game.height/2 + i*Tile.TILE_SIZE;

      }

      else {
        _x = Luxe.camera.center.x - Game.width/2 + i*Tile.TILE_SIZE;

        if (Game.direction == up) {
          _y = Luxe.camera.center.y - Game.height/2 - Tile.TILE_SIZE*2;
        }
        else {
          _y = Luxe.camera.center.y + Game.height/2 + Tile.TILE_SIZE*2;
        }
      }

      _x = Math.floor(_x/16)*16;
      _y = Math.floor(_y/16)*16;

      new Tile({
        pos: new Vector(_x, _y),
      });
    }
  }



  function next_crate_cd() {
    crate_cd = crate_max_cd + Math.random()*2 - Game.difficulty*1.3;
  }

  function spawn_crate() {

    new Crate({
      pos: Spawner.pick_place(front),
      scene: Game.scene,
    });

    next_crate_cd();
  }

}

typedef SpawnEvent = {
  var pos:Vector;
  @:optional var velocity:Vector;
  @:optional var speed:Float;
  @:optional var angle:Float;
  @:optional var depth:Float;
}

enum SpawnPlace {
  still;
  front;
  back;
  sides;
  left;
  right;
}
