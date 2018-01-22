
using polyfills.ArrayTools;

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
        return (
          !sameAsLastOne &&
          (
            seq.difficulty < 0 ||
            (seq.difficulty > Game.difficulty - 0.15 && seq.difficulty < Game.difficulty + 0.15)
          )
        )
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

  public function update(dt):Bool{
    return current_sequence.update(dt);
  }
}