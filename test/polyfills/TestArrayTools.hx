package test.polyfills;

import utest.Runner;
import utest.ui.Report;
import utest.Assert;

using polyfills.ArrayTools;

class TestArrayTools {
  public function new(){}
  
  public function testFind() {
    // Find the string with 3 digits
    var arr:Array<String> = ['4444', '22', '7777777', '333', '55555'];
    var found = arr.find(function(curr:String, ?_, ?_){
      return curr.length == 3;
    });
    // Assert.equals(found, '333');
  }
}
