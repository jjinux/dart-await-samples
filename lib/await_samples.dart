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
 * Test the "Basic function structure" transformation.
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
 * Test the "Simple statement" and "await" transformations.
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
      value = __prevBookmark.variables["value"];
      __prevBookmark = null;
      __completer.complete(value);
      return __completer.future;
    }
    
    return __completer.future;
  }

  return _simpleStatement(null, value);
}
