import enemies.Gal;
import luxe.Entity;
import luxe.Scene;
import luxe.Sprite;
import luxe.States;

import luxe.collision.ShapeDrawerLuxe;
import luxe.tween.Actuate;
import luxe.utils.Random;
import phoenix.Vector;
import snow.api.Timer;

class Game extends State {

  public inline static var screenWidth:Int = 642;
  public inline static var screenHeight:Int = 576;
  public inline static var width:Int = 214;
  public inline static var height:Int = 192;
  public inline static var fixedDelta:Float = 1/60;

  var player:Player;
  var lightmask:Sprite;
  var gal:Gal;

  var spawner:Spawner;

  var hud:Hud;
  var debugKeys:debug.KeyListener;

  var _realCamPos:Vector;
  var _camTravelled:Float;
  var camTimer:Timer;




  // Just an array to hold all game's events, to remove
  var game_events:Array<String>;

  public static var random:Random;

  public static var scene:Scene;

  public static var level:Int;
  public static var gameType:GameType;

  // is game on? If not, then it's probably preparing (startup stuff)
  public static var playing:Bool = false;

  // Did we just loose?
  public static var gameover:Bool = false;
  public static var gal_game_over:Bool = false;

  // quick delay during gameplay, like getting mushroom in Mario
  public static var delayed:Bool = false;

  // Is tutorial sequence should be playing?
  public static var tutorial:Bool = false;

  public static var difficulty:Float = 0;
  public static var time:Float = 0;
  public static var hope:Float = 1;
  public static var love:Int = 0;


  // Distance to Gal
  var gal_distance_start:Float;
  public static var gal_distance:Float;

  // How fast are we running to her normally?
  public static var gal_mult:Float;

  // How much hope are we loosing each update?
  public static var hope_mult:Float;


  public static var speed:Float = 6000;
  // Distance travelled (what)
  public static var distance:Float = 0;

  public static var direction:Direction = right;
  public static function directional_vector():Vector {
    var _vec:Vector = new Vector(speed/100, 0);
    // trace('---------------before and after--------------');
    // trace(Game.direction.getName());
    // trace(_vec);
    switch (Game.direction) {
      case Direction.right: _vec.angle2D = 0;
      case Direction.down:  _vec.angle2D = Math.PI/2;
      case Direction.left:  _vec.angle2D = Math.PI;
      case Direction.up:    _vec.angle2D = 3*Math.PI/2;
    }

    // trace(_vec);
    return _vec.clone();
  }

  override public function new (options:GameOptions) {
    super({name: 'game'});

    Game.gal_mult = options.gal_mult;
    Game.hope_mult = options.hope_mult;
    gal_distance_start = options.gal_distance_start;

    Game.tutorial = options.tutorial;


    Game.random = new Random(Math.random());

    Game.scene = new Scene('gamescene');

    Game.level = 1;
    Game.gameType = classic;

    Game.drawer = new ShapeDrawerLuxe();

    _realCamPos = new Vector();
    // camTimer = Luxe.timer.schedule(1/60, update_camera, true);
  }

  override function onleave<T>(_:T) {
    hud.destroy();
    debugKeys.destroy();
    player.destroy();
    lightmask.destroy();
    kill_events();
    spawner.destroy();
    Game.scene.empty();

    var _arr:Array<Entity> = new Array<Entity>();
    _arr = Luxe.scene.get_named_like('tile', _arr);

    for (e in _arr) {
      e.destroy();
    }

    Luxe.camera.pos.set_xy(0, 0);
  }

  override function onenter<T>(_:T) {
    reset();

    create_hud();
    create_debugKeys();
    create_player();
    create_lightmask();

    init_events();

    spawner = new Spawner({name: 'spawner'});
    _camTravelled = 0;


    Luxe.timer.schedule(3, function() {
      playing = true;
      Luxe.events.fire('game.start');
    });


    Luxe.events.fire('game.init');

  }

  function reset() {
    Game.difficulty = 0;
    Game.time = 0;
    Game.hope = 1;
    Game.love = 0;
    Game.gal_distance = gal_distance_start;

    Game.direction = right;

    Game.distance = 0;

    Game.playing = false;
    Game.gameover = false;
    Game.gal_game_over = false;
    Game.delayed = false;


    Luxe.camera.pos.set_xy(0, 0);
    _realCamPos.copy_from(Luxe.camera.pos);

    // random.seed = Math.random();

    Luxe.events.fire('game.reset');
  }

  function game_over(reason:String) {
    if (reason == 'gal') {
      gal_game_over = true;
    }

    Game.playing = false;
    Game.gameover = true;
    Luxe.events.fire('game.over.${reason}');
  }

  function create_hud() {
    hud = new Hud({
      name: 'hud',
    });
  }

  function create_debugKeys(){
    debugKeys = new debug.KeyListener({
      name: 'debugKeys',
    });
  }

  function create_player() {
    player = new Player({
      name: 'player',
      name_unique: true,
      texture: Luxe.resources.texture('assets/images/player.gif'),
      size: new Vector(16, 16),
      pos: Luxe.camera.center.clone(),
      centered: true,
      depth: 10,
      scene: Game.scene,
    });
    player.texture.filter_mag = nearest;
    player.texture.filter_min = nearest;
  }

  function create_lightmask() {
    lightmask = new Sprite({
      name: 'lightmask',
      texture: Luxe.resources.texture('assets/images/lightmask.png'),
      size: new Vector(512, 512),
      pos: player.pos.clone(),
      centered: true,
      depth: 50
    });
    lightmask.add(new components.Follow({
      name: 'follow',
      target: player,
      follow_type: components.Follow.FollowType.smooth,
    }));
    lightmask.add(new components.Light({
      name: 'light',
    }));
  }

  function init_events() {
    game_events = new Array<String>();

    game_events.push(Luxe.events.listen('game.gal_distance.*', function(e:GameEvent) {
      if (e.gal_distance != null) {
        Game.gal_distance += e.gal_distance;
      }
    }));
    game_events.push(Luxe.events.listen('game.hope.*', function(e:GameEvent) {
      if (e != null && e.hope != null) {
        Game.hope += e.hope;
      }
    }));

    game_events.push(Luxe.events.listen('player.hit.enemy', function(_) {
      Game.gal_distance += 0.06;
      Game.hope -= 0.05;
      Luxe.camera.shake(8);
    }));

    game_events.push(Luxe.events.listen('crate.hit.enemy', function(_) {
      Game.gal_distance -= 0.014;
      Game.hope += 0.25;
      Luxe.camera.shake(3);
    }));

    // init sweet game over!
    // First, guy goes right, bumps into gal
    game_events.push(Luxe.events.listen('game.over.gal', function(_) {
      trace('game.over.gal');
      hud.events.fire('hud.hide');
      player.events.fire('galgameover');
      Game.direction = right;


      // Remove everybody
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

      gal = new Gal({
        name: 'gal',
        name_unique: true,
        pos: new Vector(Math.floor(Luxe.camera.center.x + Game.width),  Luxe.camera.center.y),
        scene: Game.scene,
      });

      lightmask.visible = false;
    }));

    // Finally start the sequence when they touch
    game_events.push(Luxe.events.listen('player.hit.gal', function(_) {
      trace('player.hit.gal !!');
      Actuate.tween(Game, 2, {speed:0});
      spawner.events.fire('sequence.gal');
    }));

    game_events.push(Luxe.events.listen('debug_game.pause', function(_){
      Game.delayed = !Game.delayed;
    }));

    game_events.push(Luxe.events.listen('debug_game.hope.max', function(_){
      Game.hope = 1;
    }));
  }

  function kill_events() {
    for (s in game_events) {
      Luxe.events.unlisten(s);
    }
  }



  override function update(_) {
    var dt:Float = fixedDelta;
    if (Game.playing && !Game.delayed || Game.gal_game_over) {
      if (!Game.tutorial) {
        Game.hope -= dt * (Game.hope_mult * (Game.difficulty*0.5));
        Game.distance += Game.speed * (dt*100);
        Game.gal_distance -= dt * Game.gal_mult;
      }
      else {
        Game.gal_distance = gal_distance_start;
        Game.hope += dt;
      }

      Game.time += dt;

      var _v:Vector = Vector.Multiply(Game.directional_vector(), dt);

      _realCamPos.x += _v.x; // :S
      _realCamPos.y += _v.y;

      Luxe.events.fire('game.move', _v.clone());

      _camTravelled += Game.directional_vector().length * dt;

      if (_camTravelled > Tile.TILE_SIZE-1) {
        _camTravelled -= Tile.TILE_SIZE-1;
        Luxe.events.fire('spawn.tilescolrow');
      }


      if (Game.gal_distance <= 0 && !Game.gal_game_over) {
        game_over('gal');
      }

    }

    // trace( 'Gal distance: ${Game.gal_distance}' );

    if (Game.hope > 1) {
      Game.hope = 1;
    }

    if (!Game.tutorial && !Game.gameover) {
      if (Game.hope <= 0) {
        game_over('hope');
      }

      if (Game.gal_distance > 1.05) {
        game_over('distance');
      }

      Game.difficulty = 1 - Game.gal_distance;

      if (Game.difficulty > 1) {
        difficulty = 1;
      }
    }

    update_camera();

    // Game.hope = Math.sin(Game.time/2)/2 + 0.5;
  }

  function update_camera() {
    Luxe.camera.pos.copy_from(_realCamPos);
    Luxe.camera.pos.x = Math.round(Luxe.camera.pos.x);
    Luxe.camera.pos.y = Math.round(Luxe.camera.pos.y);

    if (Game.gal_game_over) {
      Luxe.camera.pos.x += 10;
    }
  }

  public static var drawer:ShapeDrawerLuxe;

  override function onrender() {

  }
}

enum GameType {
  endless;
  classic;
}

enum Direction {
  left;
  down;
  right;
  up;
}

typedef GameEvent = {
  @:optional var gal_distance:Float;
  @:optional var hope:Float;
  @:optional var difficulty:Float;
}

typedef GameOptions = {
  var hope_mult:Float;
  var gal_mult:Float;
  var gal_distance_start:Float;
  var tutorial:Bool;
}