package test.polyfills;

import utest.Assert;

using polyfills.ArrayTools;

class TestArrayTools {
  public function new(){}
  
  public function testFindString() {
    // Find the string with 3 digits
    var arr:Array<String> = ['4444', '22', '7777777', '333', '55555'];
    var found = arr.find(function(curr:String, ?_, ?_){
      return curr.length == 3;
    });
    Assert.equals('333', found);
  }
  public function testFindFloat() {
    // Find the string with 3 digits
    var arr:Array<Float> = [-5.1, -0.1, 0, 354.89];
    var found:Float;
    
    found = arr.find(function(curr:Float, ?_, ?_){
      return curr > 0;
    });
    Assert.equals(354.89, found);
    
    found = arr.find(function(curr:Float, ?_, ?_){
      return curr < 0;
    });
    Assert.equals(-5.1, found);
  }
  public function testFindIdx() {
    // IDX
    var arr:Array<Int> = [-100, 0, 50, 250];
    var i:Int = 0;
    arr.find(function(curr:Float, ?idx:Int, ?_){
      Assert.equals(i, idx, 'i = ${i}, idx = ${idx}');
      i++;
      return false;
    });
  }
  
  /**
   *  FILL
   */
  public function testFillString() {
    var arr:Array<String> = ['a', 'b', 'c', 'd'];
    var newArr:Array<String>;
    
    newArr = arr.fill('q');
    Assert.equals(['q', 'q', 'q', 'q'].toString(), newArr.toString());
    
    newArr = arr.fill('123');
    Assert.equals(['123', '123', '123', '123'].toString(), newArr.toString());
    
    newArr = arr.fill('q', 0, 4);
    Assert.equals(['q', 'q', 'q', 'q'].toString(), newArr.toString());
    
    newArr = arr.fill('q', 4, 4);
    Assert.equals(['a', 'b', 'c', 'd'].toString(), newArr.toString());
    
    newArr = arr.fill('q', 1);
    Assert.equals(['a', 'q', 'q', 'q'].toString(), newArr.toString());
    
    newArr = arr.fill('q', 2);
    Assert.equals(['a', 'b', 'q', 'q'].toString(), newArr.toString());
    
    newArr = arr.fill('q', 0, 2);
    Assert.equals(['q', 'q', 'c', 'd'].toString(), newArr.toString());
  }
  public function testFillInt() {
    var arr:Array<Int> = [123, -1234, 0, -55];
    var newArr:Array<Int>;
    
    newArr = arr.fill(0);
    Assert.equals([0, 0, 0, 0].join(','), newArr.join(','));
    newArr = arr.fill(0, 1);
    Assert.equals([123, 0, 0, 0].join(','), newArr.join(','));
    newArr = arr.fill(0, 0, 4);
    Assert.equals([0, 0, 0, 0].join(','), newArr.join(','));
    newArr = arr.fill(0, 1, 3);
    Assert.equals([123, 0, 0, -55].join(','), newArr.join(','));
    
    newArr = arr.fill(2314);
    Assert.equals([2314, 2314, 2314, 2314].join(','), newArr.join(','));
    
    newArr = arr.fill(-12);
    Assert.equals([-12, -12, -12, -12].join(','), newArr.join(','));
  }
  public function testFillFloat() {
    var arr:Array<Float> = [0.03, -3.149865, 0, -555];
    var newArr:Array<Float>;
    
    newArr = arr.fill(0);
    Assert.equals([0, 0, 0, 0].join(','), newArr.join(','));
    
    newArr = arr.fill(2314);
    Assert.equals([2314, 2314, 2314, 2314].join(','), newArr.join(','));
    
    newArr = arr.fill(-12);
    Assert.equals([-12, -12, -12, -12].join(','), newArr.join(','));
  }
  
  /**
   *  SOME
   */
  public function testSomeString() {
    var arr1:Array<String> = ['asd', 'rest245ef', 'snkdjfn', '94873289559'];
    var arr2:Array<String> = ['a', '2', 'r5', 's'];
    var arr3:Array<String> = ['aaa', 'bbb', 'ccc', 'ddd'];
    
    function hasMoreThan10Chars(elem:String, ?_, ?_):Bool {
      return elem.length > 10;
    }
    function containsNumbers(elem:String, ?_, ?_):Bool {
      return Std.is(Std.parseInt(elem), Float);
    }
    
    Assert.isTrue(arr1.some(hasMoreThan10Chars));
    Assert.isFalse(arr2.some(hasMoreThan10Chars));
    
    Assert.isTrue(arr1.some(containsNumbers));
    Assert.isTrue(arr2.some(containsNumbers));
    Assert.isFalse(arr3.some(containsNumbers));
  }
}
