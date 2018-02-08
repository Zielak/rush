package sequences;
import Action;
import actions.SpawnLineOfBomb;
import actions.SpawnCruncher;
import actions.SpawnBomb;
import actions.ChangeDirection;
import actions.Wait;
import Spawner.SpawnPlace;

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
    timeline.push({ action: SpawnCruncher, options: {prefix: 0.1, spawn_type: front}});
    timeline.push({ action: SpawnCruncher, options: {prefix: 0.1, spawn_type: front}});
    timeline.push({ action: SpawnLineOfBomb, options: {prefix: 1}});
    timeline.push({ action: SpawnLineOfBomb, options: {prefix: 1.5}});
    timeline.push({ action: SpawnCruncher, options: {prefix: 0.1, spawn_type: front}});
    timeline.push({ action: SpawnCruncher, options: {prefix: 0.1, spawn_type: front}});
    timeline.push({ action: SpawnLineOfBomb, options: {prefix: 1.5}});
    timeline.push({ action: SpawnLineOfBomb, options: {prefix: 1.5}});
    timeline.push({ action: SpawnCruncher, options: {prefix: 0.2, spawn_type: front}});
    timeline.push({ action: SpawnCruncher, options: {prefix: 0.2, spawn_type: front}});
    timeline.push({ action: SpawnCruncher, options: {prefix: 0.2, spawn_type: front}});
    timeline.push({ action: SpawnLineOfBomb, options: {prefix: 1.5}});
    sequences.push(new Sequence({name:'HELL line of bombs', timeline: timeline, postfix: 1.5, difficulty: 0.7}));


    // Spawn stationary bombs
    timeline = [];

    for (i in 0...13) {
      timeline.push({action: SpawnBomb, options: {prefix: 0.6}});
    }

    sequences.push(new Sequence({name:'bombs', timeline: timeline, difficulty: 0.05}));

    // Spawn MORE BOMBS
    timeline = [];

    for (i in 0...18) {
      timeline.push({action: SpawnBomb, options: {prefix: 0.45}});
    }

    sequences.push(new Sequence({name:'MORE bombs', timeline: timeline, difficulty: 0.17}));

    // BOMB HELL
    timeline = [];

    for (i in 0...16) {
      timeline.push({action: SpawnBomb, options: {prefix: 0.5}});
      timeline.push({action: SpawnBomb});
    }

    sequences.push(new Sequence({name:'HELL bombs', timeline: timeline, difficulty: 0.55}));


    // UBER MENSH BOMBORDIER
    timeline = [];

    for (i in 0...13) {
      timeline.push({
        action: SpawnBomb,
        options: {prefix: 0.3}
      });
      timeline.push({
        action: SpawnBomb,
        options: {prefix: 0.45}
      });
      timeline.push({
        action: SpawnCruncher,
        options: {prefix: 0.2, spawn_type: front}
      });
    }

    sequences.push(new Sequence({name:'UBER bombs', timeline: timeline, difficulty: 0.69}));





    // HARDCORE MIX of Bombs and Crunchers!
    timeline = [];

    for (i in 0...13) {
      timeline.push({action: SpawnBomb, options: {prefix: 0.5}});
      timeline.push({action: SpawnBomb, options: {prefix: 0.3}});
    }

    timeline.push({action: SpawnCruncher, options: {prefix: 0.3, spawn_type: back}});
    timeline.push({action: SpawnCruncher, options: {prefix: 0.1, spawn_type: front}});
    timeline.push({action: SpawnCruncher, options: {prefix: 0.1, spawn_type: back}});

    for (i in 0...15) {
      timeline.push({action: SpawnBomb, options: {prefix: 0.25}});
      timeline.push({action: SpawnBomb, options: {prefix: 0.2}});
    }

    timeline.push({action: SpawnCruncher, options: {prefix: 0.3, spawn_type: front}});
    timeline.push({action: SpawnCruncher, options: {prefix: 0.1, spawn_type: back}});
    timeline.push({action: SpawnCruncher, options: {prefix: 0.1, spawn_type: front}});

    for (i in 0...15) {
      timeline.push({action: SpawnBomb, options: {prefix: 0.2}});
      timeline.push({action: SpawnBomb, options: {prefix: 0.2}});
    }

    sequences.push(new Sequence({name:'HARDCORE MIX', timeline: timeline, difficulty: 0.6}));
    sequences.push(new Sequence({name:'HARDCORE MIX', timeline: timeline, difficulty: 0.89}));






    // Spawn FRONTAL Crunchers
    timeline = [];

    for (i in 0...4) {
      timeline.push({
        action: SpawnCruncher,
        options: {
          prefix: 1, spawn_type: front
        }
      });
    }

    sequences.push(new Sequence({name:'frontal crunchers', timeline: timeline, prefix: 0.5, difficulty: 0.1}));

    // Spawn more frontal Crunchers
    timeline = [];

    for (i in 0...6) {
      timeline.push({action: SpawnCruncher,
      options: {
        prefix: 0.7, spawn_type: front
      }});
    }

    sequences.push(new Sequence({name:'MORE frontal crunchers', timeline: timeline, prefix: 0.25, difficulty: 0.35}));






    // Spawn BACK Crunchers
    timeline = [];

    for (i in 0...4) {
      timeline.push({action: SpawnCruncher,
      options: {
        prefix: 1.5, spawn_type: back
      }});
    }

    sequences.push(new Sequence({name:'back crunchers', timeline: timeline, difficulty: 0}));

    // Spawn HELL of BACK Crunchers
    timeline = [];

    for (i in 0...10) {
      timeline.push({action: SpawnCruncher,
      options: {
        prefix: 0.7, spawn_type: back
      }});
    }

    sequences.push(new Sequence({name:'HELL back crunchers', timeline: timeline, difficulty: 0.7}));







    // Spawn BACK & FRONT Crunchers
    timeline = [];

    for (i in 0...10) {
      timeline.push({action: SpawnCruncher,
      options: {
        prefix: 1, spawn_type: back
      }});
      timeline.push({action: SpawnCruncher,
      options: {
        prefix: 0, spawn_type: front
      }});
    }

    sequences.push(new Sequence({name:'front&back crunchers', timeline: timeline, prefix: 0, difficulty: 0.2}));



    // Spawn MORE BACK & FRONT Crunchers
    timeline = [];

    for (i in 0...12) {
      timeline.push({action: SpawnCruncher,
      options: {
        prefix: 0.65, spawn_type: back
      }});
      timeline.push({action: SpawnCruncher,
      options: {
        prefix: 0.1, spawn_type: front
      }});
    }

    sequences.push(new Sequence({name:'MORE front&back crunchers', timeline: timeline, prefix: 0, difficulty: 0.4}));




    // Spawn UBER SPIEL BACK & FRONT Crunchers
    timeline = [];

    for (i in 0...30) {
      timeline.push({
        action: SpawnCruncher,
        options: {
          prefix: 0.5, spawn_type: back
        }
      });
      timeline.push({
        action: SpawnCruncher,
        options: {
          prefix: 0.2, spawn_type: front
        }
      });
    }

    sequences.push(new Sequence({name:'UBER SPIEL', timeline: timeline, prefix: 0.3, difficulty: 0.9}));




    // Change direction
    timeline = [];
    timeline.push({action: ChangeDirection, options: {prefix: 1.5}});
    timeline.push({action: Wait, options: {prefix: 1.5}});
    sequences.push(new Sequence({name:'change direction', timeline: timeline, difficulty: -1}));

  }
}