/**
 * Test out the transformation in my new approach to await for Dart.
 * 
 * Show proposed examples, and then show what those examples look like
 * after manually applying the transformation specified in the spec.
 * 
 * See: http://goto.google.com/new-approach-to-await
 */

library await_samples;
import "dart:isolate";

/// This is taken directly from the spec.
class Bookmark {
  Set<String> locations;
  Map variables;

  Bookmark() {
    locations = new Set<String>();
    variables = {};
  }

  Bookmark.from(Bookmark other) {
    locations = new Set<String>.from(other.locations);
    variables = new Map.from(other.variables);
  }
}

/// This is just an example asynchronous function that I can use for testing.
Future<int> incrementSlowly(int i) {
  var completer = new Completer<int>();
  new Timer(0, (t) => completer.complete(i + 1));
  return completer.future;
}

/**
 * Test the basic function structure.
 * 
 *   async int wrapWithFuture(int value) {
 *     return value;
 *   }
 */
Future<int> wrapWithFuture(int value) {

  Future<int> _wrapWithFuture(Bookmark __prevBookmark, int value) {
    Completer<int> __completer = new Completer<int>();
    Bookmark __nextBookmark = new Bookmark();
    __completer.complete(value);
    return __completer.future;
  }

  return _wrapWithFuture(null, value);
}

/**
 * Test simple statements and await.
 * 
 *   async int simpleStatement(int value) {
 *     value++;
 *     value <- incrementSlowly(value);
 *     return value;
 *   }
*/
Future<int> simpleStatement(int value) {

  Future<int> _simpleStatement(Bookmark __prevBookmark, int value) {
    Completer<int> __completer = new Completer<int>();
    Bookmark __nextBookmark = new Bookmark();
    __nextBookmark.variables["value"] = value;

    if (__prevBookmark == null) {
      value++;
    }
    
    if (__prevBookmark == null) {
      incrementSlowly(value).then((__value) {
        __nextBookmark.locations.add("await1");
        __nextBookmark.variables["value"] = __value;
        Bookmark __copy = new Bookmark.from(__nextBookmark);
        _simpleStatement(__copy, value).then((__value) {
          __completer.complete(__value);
        });
      });
      return __completer.future;
    }
    
    if (__prevBookmark.locations.contains("await1")) {
      value = __nextBookmark.variables["value"] = __prevBookmark.variables["value"];
      __prevBookmark = null;
    }
    
    __completer.complete(value);
    return __completer.future;
  }

  return _simpleStatement(null, value);
}

/**
 * Test while, await, compound operators, and the decrement operator.
 * 
 *   async int whileLoop(int value) {
 *     int sum = 0;
 *     while (value > 0) {
 *       int returnedValue <- wrapWithFuture(value);
 *       sum += returnedValue;
 *       value--;
 *     }
 *     return sum;
 *   }   
 */
Future<int> whileLoop(int value) {

  Future<int> _whileLoop(Bookmark __prevBookmark, int value) {
    Completer<int> __completer = new Completer<int>();
    Bookmark __nextBookmark = new Bookmark();
    if (__prevBookmark == null) {
      __nextBookmark.variables["value"] = value;
    }
    
    int sum;
    if (__prevBookmark == null) {
      sum = __nextBookmark.variables["sum"] = 0;
    }
    
    if (__prevBookmark == null ||
        __prevBookmark.locations.contains("while1")) {
      
      __nextBookmark.locations.add("while1");
      while ((__prevBookmark != null &&
              __prevBookmark.locations.remove("while1")) ||
             (__prevBookmark == null &&
              value > 0)) {
        
        int returnedValue;
        if (__prevBookmark == null) {
          wrapWithFuture(value).then((__value) {
            __nextBookmark.locations.add("await1");
            __nextBookmark.variables["returnedValue"] = __value;
            Bookmark __copy = new Bookmark.from(__nextBookmark);
            _whileLoop(__copy, value).then((__value) {
              __completer.complete(__value);
            });
          });
          return __completer.future;
        }
        if (__prevBookmark.locations.contains("await1")) {
          returnedValue = __nextBookmark.variables["returnedValue"] = __prevBookmark.variables["returnedValue"];
          value = __nextBookmark.variables["value"] = __prevBookmark.variables["value"];
          sum = __nextBookmark.variables["sum"] = __prevBookmark.variables["sum"];
          __prevBookmark = null;
        }        
        
        sum = __nextBookmark.variables["sum"] = sum + returnedValue;
        value = __nextBookmark.variables["value"] = value - 1;        
      }
      __nextBookmark.locations.remove("while1");
    }
    
    __completer.complete(sum);
    return __completer.future;
  }

  return _whileLoop(null, value);
}