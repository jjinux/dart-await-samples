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
class Bookmark<ReturnType> {
  Set<String> locations;
  Map variables;
  Completer<ReturnType> completer;

  Bookmark() {
    locations = new Set<String>();
    variables = {};
    assert(completer == null);
  }
  
  Bookmark.from(Bookmark other) {
    locations = new Set<String>.from(other.locations);
    variables = new Map.from(other.variables);
    completer = other.completer;
  }
}

/// Increment [i] and wrap it in a future.
Future<int> asyncIncrement(int i) {
  var completer = new Completer<int>();
  new Timer(0, (t) => completer.complete(i + 1));
  return completer.future;
}

/// This is just some random exception class I can use for testing.
class SomeException implements Exception {
  String message;
  SomeException([this.message]);
}

/// Use [Future.handleError] to "throw" the exception asynchronously. 
Future asyncThrow(Exception e) {
  var completer = new Completer();
  new Timer(0, (t) {
    completer.completeException(e);
  }); 
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
    Bookmark __nextBookmark = new Bookmark<int>();    
    if (__prevBookmark == null) {
      __nextBookmark.completer = new Completer<int>();
    } else {
      __nextBookmark.completer = __prevBookmark.completer;
    }    
    Completer<int> __completer = __nextBookmark.completer;
    if (__prevBookmark == null) {
      __nextBookmark.variables["value"] = value;
    }
    try {

      __completer.complete(value);
      return __completer.future;
    
    } catch (__e, __s) {
      __completer.completeException(__e, __s);
      return __completer.future;
    }
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
    Bookmark __nextBookmark = new Bookmark<int>();    
    if (__prevBookmark == null) {
      __nextBookmark.completer = new Completer<int>();
    } else {
      __nextBookmark.completer = __prevBookmark.completer;
    }    
    Completer<int> __completer = __nextBookmark.completer;
    if (__prevBookmark == null) {
      __nextBookmark.variables["value"] = value;
    }
    try {

      if (__prevBookmark == null) {
        value++;
      }
      
      if (__prevBookmark == null) {
        Future<int> __asyncCallFuture = asyncIncrement(value);
        
        __reEnterFunction() {
          __nextBookmark.locations.add("await1");
          Bookmark __copy = new Bookmark.from(__nextBookmark);
          _simpleStatement(__copy, value);            
        }
        
        __asyncCallFuture.then((__value) {
          __nextBookmark.variables["value"] = __value;            
          __reEnterFunction();
        });
        
        __asyncCallFuture.handleException((__e) {
          __nextBookmark.variables["__exceptionToThrow"] = __e;            
          __reEnterFunction();
          return true;
        });
        
        return __completer.future;
      }
      
      if (__prevBookmark.locations.contains("await1")) {
        value = __nextBookmark.variables["value"] = __prevBookmark.variables["value"];
        var __exceptionToThrow = __prevBookmark.variables["__exceptionToThrow"];
        __prevBookmark = null;
        if (__exceptionToThrow != null) throw __exceptionToThrow; 
      }
      
      __completer.complete(value);
      return __completer.future;
      
    } catch (__e, __s) {
      __completer.completeException(__e, __s);
      return __completer.future;
    }
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
    Bookmark __nextBookmark = new Bookmark<int>();    
    if (__prevBookmark == null) {
      __nextBookmark.completer = new Completer<int>();
    } else {
      __nextBookmark.completer = __prevBookmark.completer;
    }    
    Completer<int> __completer = __nextBookmark.completer;
    if (__prevBookmark == null) {
      __nextBookmark.variables["value"] = value;
    }
    try {

      int sum;
      if (__prevBookmark == null) {
        sum = __nextBookmark.variables["sum"] = 0;
      }
      
      if (__prevBookmark == null ||
          __prevBookmark.locations.contains("while1")) {
        
        __nextBookmark.locations.add("while1");
        while ((__prevBookmark == null &&
                value > 0) ||
               (__prevBookmark != null &&
                __prevBookmark.locations.remove("while1"))) {
  

          var returnedValue;
          if (__prevBookmark == null) {
            Future<int> __asyncCallFuture = wrapWithFuture(value);
            
            __reEnterFunction() {
              __nextBookmark.locations.add("await1");
              Bookmark __copy = new Bookmark.from(__nextBookmark);
              _whileLoop(__copy, value);            
            }
            
            __asyncCallFuture.then((__value) {
              __nextBookmark.variables["returnedValue"] = __value;            
              __reEnterFunction();
            });
            
            __asyncCallFuture.handleException((__e) {
              __nextBookmark.variables["__exceptionToThrow"] = __e;            
              __reEnterFunction();
              return true;
            });
            
            return __completer.future;
          }
          
          if (__prevBookmark.locations.contains("await1")) {
            returnedValue = __nextBookmark.variables["returnedValue"] = __prevBookmark.variables["returnedValue"];
            var __exceptionToThrow = __prevBookmark.variables["__exceptionToThrow"];
            value = __nextBookmark.variables["value"] = __prevBookmark.variables["value"];
            sum = __nextBookmark.variables["sum"] = __prevBookmark.variables["sum"];
            __prevBookmark = null;
            if (__exceptionToThrow != null) throw __exceptionToThrow; 
          }
          
          sum = __nextBookmark.variables["sum"] = sum + returnedValue;
          value = __nextBookmark.variables["value"] = value - 1;        
        }
        __nextBookmark.locations.remove("while1");
      }
      
      __completer.complete(sum);
      return __completer.future;

    } catch (__e, __s) {
      __completer.completeException(__e, __s);
      return __completer.future;
    }
  }

  return _whileLoop(null, value);
}

/**
 * Test recursion, if statements, and return statements in the middle.
 * 
 *   async int recursivelySum(int value) {
 *     if (value <= 0) {
 *       return value;
 *     }
 *     var sum <- recursivelySum(value - 1);
 *     return sum + value;
 *   }   
 */
Future<int> recursivelySum(int value) {

  Future<int> _recursivelySum(Bookmark __prevBookmark, int value) {
    Bookmark __nextBookmark = new Bookmark<int>();    
    if (__prevBookmark == null) {
      __nextBookmark.completer = new Completer<int>();
    } else {
      __nextBookmark.completer = __prevBookmark.completer;
    }    
    Completer<int> __completer = __nextBookmark.completer;
    if (__prevBookmark == null) {
      __nextBookmark.variables["value"] = value;
    }
    try {

      if ((__prevBookmark == null && value <= 0) ||
          (__prevBookmark != null &&
           __prevBookmark.locations.contains("if1"))) {
        __nextBookmark.locations.add("if1");
        
        __completer.complete(value);
        return __completer.future;
  
        __nextBookmark.locations.remove("if1");
      }
      
      var sum;
      if (__prevBookmark == null) {
        Future<int> __asyncCallFuture = recursivelySum(value - 1);
        
        __reEnterFunction() {
          __nextBookmark.locations.add("await1");
          Bookmark __copy = new Bookmark.from(__nextBookmark);
          _recursivelySum(__copy, value);            
        }
        
        __asyncCallFuture.then((__value) {
          __nextBookmark.variables["sum"] = __value;            
          __reEnterFunction();
        });
        
        __asyncCallFuture.handleException((__e) {
          __nextBookmark.variables["__exceptionToThrow"] = __e;            
          __reEnterFunction();
          return true;
        });
        
        return __completer.future;
      }
      
      if (__prevBookmark.locations.contains("await1")) {
        sum = __nextBookmark.variables["sum"] = __prevBookmark.variables["sum"];
        var __exceptionToThrow = __prevBookmark.variables["__exceptionToThrow"];
        value = __nextBookmark.variables["value"] = __prevBookmark.variables["value"];
        __prevBookmark = null;
        if (__exceptionToThrow != null) throw __exceptionToThrow; 
      }
      
      __completer.complete(sum + value);
      return __completer.future;
      
    } catch (__e, __s) {
      __completer.completeException(__e, __s);
      return __completer.future;
    }    
  }

  return _recursivelySum(null, value);
}

/**
 * Test throw.
 * 
 * async throwInMultipleWays(int value) {
 *   if (value == 0) throw new SomeException("Throw before <-");
 *   if (value == 1) {
 *     <- asyncThrow(new SomeException("Throw during <-"));
 *   }
 *   throw new SomeException("Throw after <-");
 * }
 * 
 * All three of these exceptions should be transformed into
 * [__completer.completeException].
 **/
Future throwInMultipleWays(int value) {
  Future _throwInMultipleWays(Bookmark __prevBookmark, value) {
    Bookmark __nextBookmark = new Bookmark<int>();    
    if (__prevBookmark == null) {
      __nextBookmark.completer = new Completer<int>();
    } else {
      __nextBookmark.completer = __prevBookmark.completer;
    }    
    Completer<int> __completer = __nextBookmark.completer;
    if (__prevBookmark == null) {
      __nextBookmark.variables["value"] = value;
    }
    try {
      
      if ((__prevBookmark == null && value == 0) ||
          (__prevBookmark != null &&
           __prevBookmark.locations.contains("if0"))) {
        __nextBookmark.locations.add("if0");
        
        // Throw exception for value 0
        throw new SomeException("Throw before <-");
        
        __nextBookmark.locations.remove("if0");
      }
      
      if ((__prevBookmark == null && value == 1) ||
          (__prevBookmark != null &&
           __prevBookmark.locations.contains("if1"))) {
        __nextBookmark.locations.add("if1");
  
        var __ignored1;
        if (__prevBookmark == null) {
          
          // Async throw for value 1
          Future __asyncCallFuture = asyncThrow(new SomeException("Throw during <-"));
          
          __reEnterFunction() {
            __nextBookmark.locations.add("await1");
            Bookmark __copy = new Bookmark.from(__nextBookmark);
            _throwInMultipleWays(__copy, value);            
          }
          
          __asyncCallFuture.then((__value) {
            __nextBookmark.variables["__ignored1"] = __value;            
            __reEnterFunction();
          });
          
          // handleException for value 1 by re-entering the function
          // and throwing it there.
          __asyncCallFuture.handleException((__e) {
            __nextBookmark.variables["__exceptionToThrow"] = __e;            
            __reEnterFunction();
            return true;
          });
          
          return __completer.future;
        }
        
        if (__prevBookmark.locations.contains("await1")) {
          __ignored1 = __nextBookmark.variables["__ignored1"] = __prevBookmark.variables["__ignored1"];
          var __exceptionToThrow = __prevBookmark.variables["__exceptionToThrow"];
          value = __nextBookmark.variables["value"] = __prevBookmark.variables["value"];
          __prevBookmark = null;
          if (__exceptionToThrow != null) throw __exceptionToThrow; 
        }
  
        __nextBookmark.locations.remove("if1");
      }
  
      // Throw exception for value 2
      throw new SomeException("Throw after <-");

      __completer.complete(null);
      return __completer.future;
      
    // All 3 unhandled exceptions should propagate to here. 
    } catch (__e, __s) {
      __completer.completeException(__e, __s);
      return __completer.future;
    }    
  }

  return _throwInMultipleWays(null, value);
}

