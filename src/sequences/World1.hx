package sequences;
import Action;
import actions.SpawnLineOfBomb;
import actions.SpawnCruncher;

class World1 extends Sequences {
  override public function new (?options:luxe.options.EntityOptions) {
    super(options);

    var timeline:Array<ActionDescriptor>;

    // | line of Bombs
    timeline = [];
    timeline.push({action: SpawnLineOfBomb});
    sequences.push(new Sequence({
      name:'line of bombs', timeline: timeline, duration: 0.5, difficulty: 0.03
    }));
    sequences.push(new Sequence({
      name:'line of bombs', timeline: timeline, duration: 0.5, difficulty: 0.3
    }));
    sequences.push(new Sequence({
      name:'line of bombs', timeline: timeline, duration: 0.5, difficulty: 0.68
    }));
    sequences.push(new Sequence({
      name:'line of bombs', timeline: timeline, duration: 0.5, difficulty: 0.84
    }));

    // | MORE lines of bombs
    timeline = [];
    timeline.push({action: SpawnLineOfBomb, options: {start: 1}});
    timeline.push({action: SpawnLineOfBomb, options: {start: 2}});
    timeline.push({action: SpawnLineOfBomb, options: {start: 1.5}});
    timeline.push({action: SpawnLineOfBomb, options: {start: 1}});
    sequences.push(new Sequence({
      name:'MORE line of bombs', timeline: timeline, postfix: 1.5, difficulty: 0.33
    }));


    // HELL OF line bombs
    timeline = [];
    timeline.push({ action: SpawnCruncher, options<SpawnCruncherOptions>: {delay: 0.1, spawn_type: front});
    timeline.push({ action: SpawnCruncher, options: {delay: 0.1, spawn_type: front});
    timeline.push({ action: SpawnLineOfBomb, options: {delay: 1});
    timeline.push({ action: SpawnLineOfBomb, options: {delay: 1.5});
    timeline.push({ action: SpawnCruncher, options: {delay: 0.1, spawn_type: front});
    timeline.push({ action: SpawnCruncher, options: {delay: 0.1, spawn_type: front});
    timeline.push({ action: SpawnLineOfBomb, options: {delay: 1.5});
    timeline.push({ action: SpawnLineOfBomb, options: {delay: 1.5});
    timeline.push({ action: SpawnCruncher, options: {delay: 0.2, spawn_type: front});
    timeline.push({ action: SpawnCruncher, options: {delay: 0.2, spawn_type: front});
    timeline.push({ action: SpawnCruncher, options: {delay: 0.2, spawn_type: front});
    timeline.push({ action: SpawnLineOfBomb, options: {delay: 1.5});
    sequences.push(new Sequence({name:'HELL line of bombs', actions: actions, ending: 1.5, difficulty: 0.7}));


    // Spawn stationary bombs
    timeline = [];

    for (i in 0...13) {
      actions.push(new actions.SpawnBomb({delay: 0.6}));
    }

    sequences.push(new Sequence({name:'bombs', actions: actions, difficulty: 0.05}));

    // Spawn MORE BOMBS
    timeline = [];

    for (i in 0...18) {
      actions.push(new actions.SpawnBomb({delay: 0.45}));
    }

    sequences.push(new Sequence({name:'MORE bombs', actions: actions, difficulty: 0.17}));

    // BOMB HELL
    timeline = [];

    for (i in 0...16) {
      actions.push(new actions.SpawnBomb({delay: 0.5}));
      actions.push(new actions.SpawnBomb({delay: 0}));
    }

    sequences.push(new Sequence({name:'HELL bombs', actions: actions, difficulty: 0.55}));


    // UBER MENSH BOMBORDIER
    timeline = [];

    for (i in 0...13) {
      actions.push(new actions.SpawnBomb({delay: 0.3}));
      actions.push(new actions.SpawnBomb({delay: 0.1}));
      actions.push(new SpawnCruncher({delay: 0.2, spawn_type: front}));
    }

    sequences.push(new Sequence({name:'UBER bombs', actions: actions, difficulty: 0.69}));





    // HARDCORE MIX of Bombs and Crunchers!
    timeline = [];

    for (i in 0...13) {
      actions.push(new actions.SpawnBomb({delay: 0.5}));
      actions.push(new actions.SpawnBomb({delay: 0.3}));
    }

    actions.push(new SpawnCruncher({delay: 0.3, spawn_type: back}));
    actions.push(new SpawnCruncher({delay: 0.1, spawn_type: front}));
    actions.push(new SpawnCruncher({delay: 0.1, spawn_type: back}));

    for (i in 0...15) {
      actions.push(new actions.SpawnBomb({delay: 0.25}));
      actions.push(new actions.SpawnBomb({delay: 0.2}));
    }

    actions.push(new SpawnCruncher({delay: 0.3, spawn_type: front}));
    actions.push(new SpawnCruncher({delay: 0.1, spawn_type: back}));
    actions.push(new SpawnCruncher({delay: 0.1, spawn_type: front}));

    for (i in 0...15) {
      actions.push(new actions.SpawnBomb({delay: 0.2}));
      actions.push(new actions.SpawnBomb({delay: 0.2}));
    }

    sequences.push(new Sequence({name:'HARDCORE MIX', actions: actions, difficulty: 0.6}));
    sequences.push(new Sequence({name:'HARDCORE MIX', actions: actions, difficulty: 0.89}));






    // Spawn FRONTAL Crunchers
    timeline = [];

    for (i in 0...4) {
      actions.push(new SpawnCruncher({
        delay: 1, spawn_type: front
      }));
    }

    sequences.push(new Sequence({name:'frontal crunchers', actions: actions, delay: 0.5, difficulty: 0.1}));

    // Spawn more frontal Crunchers
    timeline = [];

    for (i in 0...6) {
      actions.push(new SpawnCruncher({
        delay: 0.7, spawn_type: front
      }));
    }

    sequences.push(new Sequence({name:'MORE frontal crunchers', actions: actions, delay: 0.25, difficulty: 0.35}));






    // Spawn BACK Crunchers
    timeline = [];

    for (i in 0...4) {
      actions.push(new SpawnCruncher({
        delay: 1.5, spawn_type: back
      }));
    }

    sequences.push(new Sequence({name:'back crunchers', actions: actions, difficulty: 0}));

    // Spawn HELL of BACK Crunchers
    timeline = [];

    for (i in 0...10) {
      actions.push(new SpawnCruncher({
        delay: 0.7, spawn_type: back
      }));
    }

    sequences.push(new Sequence({name:'HELL back crunchers', actions: actions, difficulty: 0.7}));







    // Spawn BACK & FRONT Crunchers
    timeline = [];

    for (i in 0...10) {
      actions.push(new SpawnCruncher({
        delay: 1, spawn_type: back
      }));
      actions.push(new SpawnCruncher({
        delay: 0, spawn_type: front
      }));
    }

    sequences.push(new Sequence({name:'front&back crunchers', actions: actions, delay: 0, difficulty: 0.2}));



    // Spawn MORE BACK & FRONT Crunchers
    timeline = [];

    for (i in 0...12) {
      actions.push(new SpawnCruncher({
        delay: 0.65, spawn_type: back
      }));
      actions.push(new SpawnCruncher({
        delay: 0.1, spawn_type: front
      }));
    }

    sequences.push(new Sequence({name:'MORE front&back crunchers', actions: actions, delay: 0, difficulty: 0.4}));




    // Spawn UBER SPIEL BACK & FRONT Crunchers
    timeline = [];

    for (i in 0...30) {
      actions.push(new SpawnCruncher({
        delay: 0.5, spawn_type: back
      }));
      actions.push(new SpawnCruncher({
        delay: 0.2, spawn_type: front
      }));
    }

    sequences.push(new Sequence({name:'UBER SPIEL', actions: actions, delay: 0.3, difficulty: 0.9}));




    // Change direction
    timeline = [];
    actions.push(new actions.ChangeDirection({delay: 1.5}));
    actions.push(new actions.Wait({delay: 1.5}));
    sequences.push(new Sequence({name:'change direction', actions: actions, difficulty: -1}));

  }
}