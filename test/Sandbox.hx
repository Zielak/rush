package test;

class Sandbox {
  static function main(){
    var actions:Array<Base> = [];
    
    actions.push(new Base());
    actions.push(new ChildA());
    actions.push(Base.create(ChildA));
    // actions.push(Base.create(BaseOther));
  }
}

class Base {

  public static function create(classRef:Class<Base>):Base {
    return Type.createInstance(classRef, []);
  }
  
  public var time:Float = 0;
  
  public function new(){
    time = 1;
  }
}

// class BaseFactory<T> {
//   // @:generic
//   public static function create<T>():Base<T> {
//     return new Base<T>();
//   }

//   private function new () {}
// }

class ChildA extends Base {
  
}
class ChildB extends Base {
  
}
class BaseOther {
  public function new(){ }
}