
class Sequences {

  @:isVar public var sequences:Array<Sequence>;

  public var current_sequence:Sequence;
  // var currentIdx:Int;
  // public var current_sequence(default, null):Sequence;
  // function get_current_sequence():Sequence {
  //   return sequences[currentIdx];
  // }

  public var length(default, null):Int;
  function get_length():Int {
    return sequences.length;
  }

  public function new () {
    sequences = new Array<Sequence>();
    // currentIdx = 0;
  }

  public function pickSequence():Sequence {
    var _seq:Sequence;

    if (sequences.length > 0) {
      _seq = current_sequence;

      // Make array aligned to difficulty
      var _ts:Array<Sequence> = new Array<Sequence>();

      for (s in sequences) {
        if (s.difficulty < 0 ||
            (s.difficulty > Game.difficulty - 0.15 && s.difficulty < Game.difficulty + 0.15)
           ) {
          _ts.push(s);
        }
      }

      // trace('SEQUENCE: picked ${_ts.length} sequences by difficulty: ${Game.difficulty}');

      // can't be the same as last one
      // TODO: Replace with Array.filter()
      while (_seq == current_sequence) {
        _seq = _ts[ Math.floor(Math.random()*(_ts.length))] ;
      }

      // trace('SEQUENCE: chosen seq: "${_seq.name}" diff:${_seq.difficulty} ');

      current_sequence = _seq;

      // trace('SEQUENCE: sequence_duration = ${sequence_duration}');
      current_sequence.reset();
    }
    return current_sequence;
  }

  public function update(dt):Bool{
    return current_sequence.update(dt);
  }
}