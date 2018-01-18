package polyfills;

class ArrayTools {
  // TODO: not sure if its correct
  static public function fill<T>(arr:Array<T>, value:Dynamic, ?start:Int = 0, ?end:Int):Array<T> {
    // Steps 1-2.
    // if (this == null) {
    //   throw new TypeError('this is null or not defined');
    // }
    var newArr:Array<T> = arr.copy();

    // var O = Object(this);

    // Steps 3-5.
    var len = arr.length >>> 0;

    // Steps 6-7.
    var relativeStart = start >> 0;

    // Step 8.
    var k:Int = (relativeStart < 0) ?
      Std.int(Math.max(len + relativeStart, 0)) :
      Std.int(Math.min(relativeStart, len));

    // Steps 9-10.
    var relativeEnd = end == null ?
      len : end >> 0;

    // Step 11.
    var fin = relativeEnd < 0 ?
      Math.max(len + relativeEnd, 0) :
      Math.min(relativeEnd, len);

    // Step 12.
    while (k < fin) {
      newArr[k] = value;
      k++;
    }

    // Step 13.
    return newArr;
  }

  static public function find<T>(arr:Array<T>, predicate:(T -> ?Int -> ?Array<T> -> Bool)):T {
    // 1. Let O be ? ToObject(this value).
    // if (this == null) {
    //   throw '"this" is null or not defined';
    // }

    // var o = Object(this);

    // 2. Let len be ? ToLength(? Get(O, "length")).
    var len:Int = arr.length >>> 0;

    // 3. If IsCallable(predicate) is false, throw a TypeError exception.
    if (!Reflect.isFunction(predicate)) {
      throw 'predicate must be a function';
    }

    // 4. If thisArg was supplied, let T be thisArg; else let T be undefined.
    // var thisArg = arguments[1];

    // 5. Let k be 0.
    var k:Int = 0;

    // 6. Repeat, while k < len
    while (k < len) {
      // a. Let Pk be ! ToString(k).
      // b. Let kValue be ? Get(O, Pk).
      // c. Let testResult be ToBoolean(? Call(predicate, T, « kValue, k, O »)).
      // d. If testResult is true, return kValue.
      var kValue:Dynamic = arr[k];
      if (predicate(kValue, k, arr)) {
        return kValue;
      }
      // e. Increase k by 1.
      k++;
    }

    // 7. Return undefined.
    return null;
  }
  
  static public function some<T>(arr:Array<T>, fun:(T -> ?Int -> ?Array<T> -> Bool)):Bool {
    var len = arr.length >>> 0;

    for (i in 0...len) {
      if (fun(arr[i], i, arr)) {
        return true;
      }
    }

    return false;
  }
}
