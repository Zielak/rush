import luxe.GameConfig;
import luxe.Color;
import luxe.components.sprite.SpriteAnimation;
import luxe.Entity;
import luxe.Input;
import luxe.resource.Resource.AudioResource;
import luxe.Audio.AudioHandle;
import luxe.Audio;
import luxe.Sprite;
import luxe.States;
import luxe.Timer;
import luxe.Vector;
import phoenix.Texture;

class Main extends luxe.Game {

  var musicRushLoop:AudioResource;
  var musicRushIntro:AudioResource;
  var musicRushEnding:AudioResource;

  var musicHandle:AudioHandle;

  var musicMuted:Bool = false;

  var machine:States;

  var shader:Entity;

  override public function config(_config:GameConfig) : luxe.GameConfig {

    // Screens
    _config.preload.textures.push({ id:'assets/images/faderBlack.gif' });
    _config.preload.textures.push({ id:'assets/images/rush_logo.gif' });
    _config.preload.textures.push({ id:'assets/images/rush_logo_bg.gif' });
    _config.preload.textures.push({ id:'assets/images/intro_darekLogo.gif' });
    _config.preload.textures.push({ id:'assets/images/intro_music.gif' });
    _config.preload.textures.push({ id:'assets/images/intro_gbjam.gif' });
    _config.preload.textures.push({ id:'assets/images/text.gif' });
    _config.preload.textures.push({ id:'assets/images/help.gif' });

    // Player
    _config.preload.textures.push({ id:'assets/images/player.gif' });
    _config.preload.textures.push({ id:'assets/images/gal.gif' });

    // Enemies
    _config.preload.textures.push({ id:'assets/images/cruncher.gif' });
    _config.preload.textures.push({ id:'assets/images/bomb.gif' });
    _config.preload.textures.push({ id:'assets/images/crate.gif' });

    // HUD
    _config.preload.textures.push({ id:'assets/images/hud.gif' });
    _config.preload.textures.push({ id:'assets/images/hearth.gif' });
    _config.preload.textures.push({ id:'assets/images/cursor.gif' });

    // World
    _config.preload.textures.push({ id:'assets/images/tiles.gif' });
    _config.preload.textures.push({ id:'assets/images/lightmask.png' });
    _config.preload.textures.push({ id:'assets/images/puff.gif' });

    /*

    // Sounds
    _config.preload.sounds.push({ id:'assets/sounds/Rush_Explosion.ogg', is_stream:false });
    _config.preload.sounds.push({ id:'assets/sounds/Rush_Grab_Box.ogg', is_stream:false });
    _config.preload.sounds.push({ id:'assets/sounds/Rush_Throw_Crate.ogg', is_stream:false });
    _config.preload.sounds.push({ id:'assets/sounds/Rush_Jump.ogg', is_stream:false });
    _config.preload.sounds.push({ id:'assets/sounds/cruncher_die.ogg', is_stream:false });
    _config.preload.sounds.push({ id:'assets/sounds/crate_break.ogg', is_stream:false });
    _config.preload.sounds.push({ id:'assets/sounds/start.ogg', is_stream:false });

    // Music
    _config.preload.sounds.push({ id:'assets/music/musicRushIntro.ogg', is_stream:true });
    _config.preload.sounds.push({ id:'assets/music/musicRushEnding.ogg', is_stream:true });
    _config.preload.sounds.push({ id:'assets/music/Go_Get_Her.ogg', is_stream:true });

    */

    // Shaders
    _config.preload.shaders.push({
      id:"lowres", frag_id:"assets/shaders/lowres.glsl", vert_id:"default"
    });

    return _config;

  }

  override function ready() {

    Luxe.renderer.clear_color = new Color().rgb(C.c1);
    Luxe.camera.zoom = 4;
    Luxe.camera.pos.set_xy(-Game.width*1.5, -Game.height*1.5);

    // Machines
    machine = new States({ name:'statemachine' });

    machine.add(new IntroState());
    machine.add(new MenuState());
    machine.add(new Game({
      gal_mult: 0.0053,
      gal_distance_start: 0.95,
      hope_mult: 0.1,
      tutorial: true,
    }));
    // machine.add( new GameOverState() );

    machine.set('intro');



    shader = new Entity({
      name: 'entity',
    });
    shader.add(new components.LowresShader({
      name: 'lowres',
      pixel_size: new Vector(Game.width/Luxe.camera.zoom, Game.height/Luxe.camera.zoom),
    }));

    init_events();

    init_audio();

  } //ready

  function startLoop(_) {
    Luxe.audio.loop(musicRushLoop.source);
    Luxe.audio.off(ae_end, startLoop);
  }

  function init_events() {
    Luxe.events.listen('game.over.quit', function(_) {
      Luxe.timer.schedule(5, function() {
        // machine.set('gameover');
      });
      machine.set('menu');
    });

    Luxe.events.listen('state.intro.finished', function(_) {
      machine.set('menu');
    });

    Luxe.events.listen('state.menu.finished', function(_) {
      machine.set('game');
    });


    // player pressed start in main menu
    Luxe.events.listen('state.menu.start_game', function(_) {
      // stop music just in case
      Luxe.audio.stop(musicHandle);
    });

    // player enters the Game State
    Luxe.events.listen('game.init', function(_) {
      // stop everything just in case
      Luxe.audio.stop(musicHandle);
      Luxe.audio.play(musicRushIntro.source);
      Luxe.audio.on(ae_end, startLoop);
    });

    Luxe.events.listen('game.over.*', function(_) {
      Luxe.audio.stop(musicHandle);
      Luxe.audio.off(ae_end, startLoop);
    });

    Luxe.events.listen('game.over.gal', function(_) {
      Luxe.audio.stop(musicHandle);
      Luxe.audio.play(musicRushEnding.source);
    });
  }

  function init_audio() {
    // Luxe.audio.on("musicRushEnding", "load", function(e){
    //     musicRushEnding = e;
    //     musicRushEnding.volume = 0.2;
    // });

    // Luxe.audio.on("musicRushIntro", "load", function(e){
    //     musicRushIntro = e;
    //     musicRushIntro.volume = 0.2;
    // });

    // Luxe.audio.on("musicRushLoop", "load", function(e){
    //     musicRushLoop = e;
    //     musicRushLoop.volume = 0.33;
    // });

    Luxe.audio.volume(musicHandle, 0.2);

    musicHandle = Luxe.audio.loop(musicRushEnding.source);
  }

  override function onkeyup(e:KeyEvent) {

    if (e.keycode == Key.escape) {
      // Luxe.shutdown();
    }

    // MUTE Music
    if (e.keycode == Key.key_m) {
      musicMuted = !musicMuted;
      Luxe.audio.volume(
        musicHandle,
        Luxe.audio.volume_of(musicHandle) > 0 ? 0 : 0.2
      );
    }

  } //onkeyup

  override function update(dt:Float) {

  } //update



  /**
   * Shader stuff
   */
  override function onprerender() {
    shader.get('lowres').onprerender();
  }

  override function onpostrender() {
    shader.get('lowres').onpostrender();
  }


} //Main




class GameOverState extends State {

  override public function new () {
    super({ name:'gameover' });
  }
}


