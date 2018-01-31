using polyfills.ArrayTools;

import luxe.Entity;

class Sequences extends Entity {

  public var sequences:Array<Sequence>;

  public var current_sequence:Sequence;

  public var length(default, null):Int;
  function get_length():Int {
    return sequences.length;
  }

  public function new (options:luxe.options.EntityOptions) {
    super(options);
    sequences = new Array<Sequence>();

    initEvents();
  }

  function initEvents() {
    // Global
    Luxe.events.listen('debug_sequence.finish', function(_){
      current_sequence._finish();
    });
    Luxe.events.listen('debug_sequence.next', function(_){
      pickSequence();
    });
  }

  public function pickSequence(?name:String):Sequence {
    var _seq:Sequence;
    if (name != null) {
      _seq = sequences.find(function(seq, ?_, ?_){
        return seq.name == name;
      });
      if(_seq != null) {
        current_sequence = _seq;
        return current_sequence;
      } else {
        trace('SEQUENCE: can\'t find sequence: ');
      }
    }
    if (sequences.length > 0) {
      // Make array aligned to difficulty
      var _ts:Array<Sequence> = sequences.filter(function(seq):Bool {
        var sameAsLastOne:Bool = seq == current_sequence;
        return !sameAsLastOne && (
          seq.difficulty < 0 ||
          (seq.difficulty > Game.difficulty - 0.15 && seq.difficulty < Game.difficulty + 0.15)
        );
      });

      // trace('SEQUENCE: picked ${_ts.length} sequences by difficulty: ${Game.difficulty}');
      _seq = _ts[Math.floor(Math.random()*(_ts.length))];
      // trace('SEQUENCE: chosen seq: "${_seq.name}" diff:${_seq.difficulty} ');

      current_sequence = _seq;

      // trace('SEQUENCE: sequence_duration = ${sequence_duration}');
      current_sequence.reset();
    }
    return current_sequence;
  }

  override public function update(dt:Float) {
    current_sequence.update(dt);
  }
}
