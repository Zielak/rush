package test;

using polyfills.ArrayTools;

class ArrayToolsTest extends haxe.unit.TestCase {
  public function testFind() {
    // Find the string with 3 digits
    var arr:Array<Dynamic> = ['4444', '22', '7777777', '333', '55555'];
    var found = arr.find(function(curr:String){
      return curr.length == 3
    }
    assertEquals(found, '333');
  }
}