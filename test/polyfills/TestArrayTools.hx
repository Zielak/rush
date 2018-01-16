package test.polyfills;

import utest.Assert;

using polyfills.ArrayTools;

class TestArrayTools {
  public function new(){}
  
  public function testFind() {
    trace('hello, testFind()');
    // Find the string with 3 digits
    var arr:Array<String> = ['4444', '22', '7777777', '333', '55555'];
    var found = arr.find(function(curr:String, ?_, ?_){
      return curr.length == 3;
    });
    Assert.equals('333', found);
  }
}
