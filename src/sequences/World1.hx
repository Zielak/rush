package sequences;

class World1 extends Sequences {
  override public function new (?options:luxe.options.EntityOptions) {
    super(options);

    var actions:Array<Action>;

    // | line of Bombs
    actions = new Array<Action>();
    actions.push(new actions.SpawnLineOfBomb({delay: 0.5}));
    sequences.push(new Sequence({name:'line of bombs', actions: actions, difficulty: 0.03}));
    sequences.push(new Sequence({name:'line of bombs', actions: actions, difficulty: 0.3}));
    sequences.push(new Sequence({name:'line of bombs', actions: actions, difficulty: 0.68}));
    sequences.push(new Sequence({name:'line of bombs', actions: actions, difficulty: 0.84}));

    // | MORE lines of bombs
    actions = new Array<Action>();
    actions.push(new actions.SpawnLineOfBomb({delay: 1}));
    actions.push(new actions.SpawnLineOfBomb({delay: 2}));
    actions.push(new actions.SpawnLineOfBomb({delay: 1.5}));
    actions.push(new actions.SpawnLineOfBomb({delay: 1}));
    sequences.push(new Sequence({name:'MORE line of bombs', actions: actions, ending: 1.5, difficulty: 0.33}));


    // HELL OF line bombs
    actions = new Array<Action>();
    actions.push(new actions.SpawnCruncher({delay: 0.1, spawn_type: front}));
    actions.push(new actions.SpawnCruncher({delay: 0.1, spawn_type: front}));
    actions.push(new actions.SpawnLineOfBomb({delay: 1}));
    actions.push(new actions.SpawnLineOfBomb({delay: 1.5}));
    actions.push(new actions.SpawnCruncher({delay: 0.1, spawn_type: front}));
    actions.push(new actions.SpawnCruncher({delay: 0.1, spawn_type: front}));
    actions.push(new actions.SpawnLineOfBomb({delay: 1.5}));
    actions.push(new actions.SpawnLineOfBomb({delay: 1.5}));
    actions.push(new actions.SpawnCruncher({delay: 0.2, spawn_type: front}));
    actions.push(new actions.SpawnCruncher({delay: 0.2, spawn_type: front}));
    actions.push(new actions.SpawnCruncher({delay: 0.2, spawn_type: front}));
    actions.push(new actions.SpawnLineOfBomb({delay: 1.5}));
    sequences.push(new Sequence({name:'HELL line of bombs', actions: actions, ending: 1.5, difficulty: 0.7}));


    // Spawn stationary bombs
    actions = new Array<Action>();

    for (i in 0...13) {
      actions.push(new actions.SpawnBomb({delay: 0.6}));
    }

    sequences.push(new Sequence({name:'bombs', actions: actions, difficulty: 0.05}));

    // Spawn MORE BOMBS
    actions = new Array<Action>();

    for (i in 0...18) {
      actions.push(new actions.SpawnBomb({delay: 0.45}));
    }

    sequences.push(new Sequence({name:'MORE bombs', actions: actions, difficulty: 0.17}));

    // BOMB HELL
    actions = new Array<Action>();

    for (i in 0...16) {
      actions.push(new actions.SpawnBomb({delay: 0.5}));
      actions.push(new actions.SpawnBomb({delay: 0}));
    }

    sequences.push(new Sequence({name:'HELL bombs', actions: actions, difficulty: 0.55}));


    // UBER MENSH BOMBORDIER
    actions = new Array<Action>();

    for (i in 0...13) {
      actions.push(new actions.SpawnBomb({delay: 0.3}));
      actions.push(new actions.SpawnBomb({delay: 0.1}));
      actions.push(new actions.SpawnCruncher({delay: 0.2, spawn_type: front}));
    }

    sequences.push(new Sequence({name:'UBER bombs', actions: actions, difficulty: 0.69}));





    // HARDCORE MIX of Bombs and Crunchers!
    actions = new Array<Action>();

    for (i in 0...13) {
      actions.push(new actions.SpawnBomb({delay: 0.5}));
      actions.push(new actions.SpawnBomb({delay: 0.3}));
    }

    actions.push(new actions.SpawnCruncher({delay: 0.3, spawn_type: back}));
    actions.push(new actions.SpawnCruncher({delay: 0.1, spawn_type: front}));
    actions.push(new actions.SpawnCruncher({delay: 0.1, spawn_type: back}));

    for (i in 0...15) {
      actions.push(new actions.SpawnBomb({delay: 0.25}));
      actions.push(new actions.SpawnBomb({delay: 0.2}));
    }

    actions.push(new actions.SpawnCruncher({delay: 0.3, spawn_type: front}));
    actions.push(new actions.SpawnCruncher({delay: 0.1, spawn_type: back}));
    actions.push(new actions.SpawnCruncher({delay: 0.1, spawn_type: front}));

    for (i in 0...15) {
      actions.push(new actions.SpawnBomb({delay: 0.2}));
      actions.push(new actions.SpawnBomb({delay: 0.2}));
    }

    sequences.push(new Sequence({name:'HARDCORE MIX', actions: actions, difficulty: 0.6}));
    sequences.push(new Sequence({name:'HARDCORE MIX', actions: actions, difficulty: 0.89}));






    // Spawn FRONTAL Crunchers
    actions = new Array<Action>();

    for (i in 0...4) {
      actions.push(new actions.SpawnCruncher({
        delay: 1, spawn_type: front
      }));
    }

    sequences.push(new Sequence({name:'frontal crunchers', actions: actions, delay: 0.5, difficulty: 0.1}));

    // Spawn more frontal Crunchers
    actions = new Array<Action>();

    for (i in 0...6) {
      actions.push(new actions.SpawnCruncher({
        delay: 0.7, spawn_type: front
      }));
    }

    sequences.push(new Sequence({name:'MORE frontal crunchers', actions: actions, delay: 0.25, difficulty: 0.35}));






    // Spawn BACK Crunchers
    actions = new Array<Action>();

    for (i in 0...4) {
      actions.push(new actions.SpawnCruncher({
        delay: 1.5, spawn_type: back
      }));
    }

    sequences.push(new Sequence({name:'back crunchers', actions: actions, difficulty: 0}));

    // Spawn HELL of BACK Crunchers
    actions = new Array<Action>();

    for (i in 0...10) {
      actions.push(new actions.SpawnCruncher({
        delay: 0.7, spawn_type: back
      }));
    }

    sequences.push(new Sequence({name:'HELL back crunchers', actions: actions, difficulty: 0.7}));







    // Spawn BACK & FRONT Crunchers
    actions = new Array<Action>();

    for (i in 0...10) {
      actions.push(new actions.SpawnCruncher({
        delay: 1, spawn_type: back
      }));
      actions.push(new actions.SpawnCruncher({
        delay: 0, spawn_type: front
      }));
    }

    sequences.push(new Sequence({name:'front&back crunchers', actions: actions, delay: 0, difficulty: 0.2}));



    // Spawn MORE BACK & FRONT Crunchers
    actions = new Array<Action>();

    for (i in 0...12) {
      actions.push(new actions.SpawnCruncher({
        delay: 0.65, spawn_type: back
      }));
      actions.push(new actions.SpawnCruncher({
        delay: 0.1, spawn_type: front
      }));
    }

    sequences.push(new Sequence({name:'MORE front&back crunchers', actions: actions, delay: 0, difficulty: 0.4}));




    // Spawn UBER SPIEL BACK & FRONT Crunchers
    actions = new Array<Action>();

    for (i in 0...30) {
      actions.push(new actions.SpawnCruncher({
        delay: 0.5, spawn_type: back
      }));
      actions.push(new actions.SpawnCruncher({
        delay: 0.2, spawn_type: front
      }));
    }

    sequences.push(new Sequence({name:'UBER SPIEL', actions: actions, delay: 0.3, difficulty: 0.9}));




    // Change direction
    actions = new Array<Action>();
    actions.push(new actions.ChangeDirection({delay: 1.5}));
    actions.push(new actions.Wait({delay: 1.5}));
    sequences.push(new Sequence({name:'change direction', actions: actions, difficulty: -1}));

  }
}