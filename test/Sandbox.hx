package test;

class Sandbox {
  static function main(){
    var arr:ActionOptionsArray = [];
    arr.push({start: 0., duration: 1.});
    arr.push({start: 2., duration: 4., test:'set'});
  }
}

@:forward
abstract ActionOptionsArray(Array<ActionOptions>) from Array<ActionOptions> to Array<ActionOptions>{
  public inline function push<T:ActionOptions>(v:T){
    return this.push(v);
  }
}

typedef ActionOptions = {
  var start:Float;
  var duration:Float;
}
typedef SecondActionOptions = {
  > ActionOptions,
  var test:Int;
}
