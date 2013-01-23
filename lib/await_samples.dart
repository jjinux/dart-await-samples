/**
 * Test out the transformation in my new approach to await for Dart.
 *
 * Show proposed examples, and then show what those examples look like
 * after manually applying the transformation specified in the spec.
 *
 * See: http://goto.google.com/new-approach-to-await
 */

library await_samples;
import "dart:async";

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
    completer.completeError(e);
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
  const __valueRef = ":value";

  Future<int> _wrapWithFuture(Bookmark __prevBookmark, int value) {
    Bookmark __nextBookmark = new Bookmark<int>();
    if (__prevBookmark == null) {
      __nextBookmark.completer = new Completer<int>();
    } else {
      __nextBookmark.completer = __prevBookmark.completer;
    }
    Completer<int> __completer = __nextBookmark.completer;
    if (__prevBookmark == null) {
      __nextBookmark.variables[__valueRef] = value;
    }
    try {

      __completer.complete(value);
      return __completer.future;

    } catch (__e, __s) {
      __completer.completeError(__e, __s);
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
  const __valueRef = ":value";

  Future<int> _simpleStatement(Bookmark __prevBookmark, int value) {
    Bookmark __nextBookmark = new Bookmark<int>();
    if (__prevBookmark == null) {
      __nextBookmark.completer = new Completer<int>();
    } else {
      __nextBookmark.completer = __prevBookmark.completer;
    }
    Completer<int> __completer = __nextBookmark.completer;
    if (__prevBookmark == null) {
      __nextBookmark.variables[__valueRef] = value;
    }
    try {

      if (__prevBookmark == null) {
        value++;
        __nextBookmark.variables[__valueRef] = value;
      }

      if (__prevBookmark == null) {
        __reEnterFunction() {
          __nextBookmark.locations.add("await0");
          Bookmark __copy = new Bookmark.from(__nextBookmark);
          _simpleStatement(__copy, value);
        }

        asyncIncrement(value).then((__value) {
          __nextBookmark.variables[__valueRef] = __value;
          __reEnterFunction();
        }).catchError((__e) {
          __nextBookmark.variables["__exceptionToThrow"] = __e.error;
          __reEnterFunction();
          return true;
        });

        return __completer.future;
      }

      if (__prevBookmark.locations.contains("await0")) {
        value = __nextBookmark.variables[__valueRef] = __prevBookmark.variables[__valueRef];
        var __exceptionToThrow = __prevBookmark.variables["__exceptionToThrow"];
        __prevBookmark = null;
        if (__exceptionToThrow != null) throw __exceptionToThrow;
      }

      __completer.complete(value);
      return __completer.future;

    } catch (__e, __s) {
      __completer.completeError(__e, __s);
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
  const __valueRef = ":value";

  Future<int> _whileLoop(Bookmark __prevBookmark, int value) {
    Bookmark __nextBookmark = new Bookmark<int>();
    if (__prevBookmark == null) {
      __nextBookmark.completer = new Completer<int>();
    } else {
      __nextBookmark.completer = __prevBookmark.completer;
    }
    Completer<int> __completer = __nextBookmark.completer;
    if (__prevBookmark == null) {
      __nextBookmark.variables[__valueRef] = value;
    }
    try {

      int sum;
      const __sumRef = ":sum";
      if (__prevBookmark == null) {
        sum = __nextBookmark.variables[__sumRef] = 0;
      }

      if (__prevBookmark == null ||
          __prevBookmark.locations.contains("while0")) {

        __nextBookmark.locations.add("while0");
        while ((__prevBookmark == null &&
                value > 0) ||
               (__prevBookmark != null &&
                __prevBookmark.locations.remove("while0"))) {


          var returnedValue;
          const __returnedValueRef = "while0:returnedValue";
          if (__prevBookmark == null) {
            __reEnterFunction() {
              __nextBookmark.locations.add("await0");
              Bookmark __copy = new Bookmark.from(__nextBookmark);
              _whileLoop(__copy, value);
            }

            wrapWithFuture(value).then((__value) {
              __nextBookmark.variables[__returnedValueRef] = __value;
              __reEnterFunction();
            }).catchError((__e) {
              __nextBookmark.variables["__exceptionToThrow"] = __e.error;
              __reEnterFunction();
              return true;
            });

            return __completer.future;
          }

          if (__prevBookmark.locations.contains("await0")) {
            returnedValue = __nextBookmark.variables[__returnedValueRef] = __prevBookmark.variables[__returnedValueRef];
            var __exceptionToThrow = __prevBookmark.variables["__exceptionToThrow"];
            value = __nextBookmark.variables[__valueRef] = __prevBookmark.variables[__valueRef];
            sum = __nextBookmark.variables[__sumRef] = __prevBookmark.variables[__sumRef];
            __prevBookmark = null;
            if (__exceptionToThrow != null) throw __exceptionToThrow;
          }

          if (__prevBookmark == null) {
            sum += returnedValue;
            __nextBookmark.variables[__sumRef] = sum;
          }
          if (__prevBookmark == null) {
            value--;
            __nextBookmark.variables[__valueRef] = value;
          }
        }
        __nextBookmark.locations.remove("while0");
      }

      __completer.complete(sum);
      return __completer.future;

    } catch (__e, __s) {
      __completer.completeError(__e, __s);
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
  const __valueRef = ":value";

  Future<int> _recursivelySum(Bookmark __prevBookmark, int value) {
    Bookmark __nextBookmark = new Bookmark<int>();
    if (__prevBookmark == null) {
      __nextBookmark.completer = new Completer<int>();
    } else {
      __nextBookmark.completer = __prevBookmark.completer;
    }
    Completer<int> __completer = __nextBookmark.completer;
    if (__prevBookmark == null) {
      __nextBookmark.variables[__valueRef] = value;
    }
    try {

      if ((__prevBookmark == null && value <= 0) ||
          (__prevBookmark != null &&
           __prevBookmark.locations.contains("if0"))) {
        __nextBookmark.locations.add("if0");

        __completer.complete(value);
        return __completer.future;

        __nextBookmark.locations.remove("if0");
      }

      var sum;
      const __sumRef = ":sum";
      if (__prevBookmark == null) {
        __reEnterFunction() {
          __nextBookmark.locations.add("await0");
          Bookmark __copy = new Bookmark.from(__nextBookmark);
          _recursivelySum(__copy, value);
        }

        recursivelySum(value - 1).then((__value) {
          __nextBookmark.variables[__sumRef] = __value;
          __reEnterFunction();
        }).catchError((__e) {
          __nextBookmark.variables["__exceptionToThrow"] = __e.error;
          __reEnterFunction();
          return true;
        });

        return __completer.future;
      }

      if (__prevBookmark.locations.contains("await0")) {
        sum = __nextBookmark.variables[__sumRef] = __prevBookmark.variables[__sumRef];
        var __exceptionToThrow = __prevBookmark.variables["__exceptionToThrow"];
        value = __nextBookmark.variables[__valueRef] = __prevBookmark.variables[__valueRef];
        __prevBookmark = null;
        if (__exceptionToThrow != null) throw __exceptionToThrow;
      }

      __completer.complete(sum + value);
      return __completer.future;

    } catch (__e, __s) {
      __completer.completeError(__e, __s);
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
 * [__completer.completeError].
 */
Future throwInMultipleWays(int value) {
  const __valueRef = ":value";

  Future _throwInMultipleWays(Bookmark __prevBookmark, value) {
    Bookmark __nextBookmark = new Bookmark<int>();
    if (__prevBookmark == null) {
      __nextBookmark.completer = new Completer<int>();
    } else {
      __nextBookmark.completer = __prevBookmark.completer;
    }
    Completer<int> __completer = __nextBookmark.completer;
    if (__prevBookmark == null) {
      __nextBookmark.variables[__valueRef] = value;
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

        var __ignored0;
        const __ignored0Ref = "if0:__ignored0";
        if (__prevBookmark == null) {
          __reEnterFunction() {
            __nextBookmark.locations.add("await0");
            Bookmark __copy = new Bookmark.from(__nextBookmark);
            _throwInMultipleWays(__copy, value);
          }

          // Async throw for value 1
          asyncThrow(new SomeException("Throw during <-")).then((__value) {
            __nextBookmark.variables[__ignored0Ref] = __value;
            __reEnterFunction();
          }).catchError((__e) {

            // catchError for value 1 by re-entering the function
            // and throwing it there.
            __nextBookmark.variables["__exceptionToThrow"] = __e.error;
            __reEnterFunction();
            return true;
          });

          return __completer.future;
        }

        if (__prevBookmark.locations.contains("await0")) {
          __ignored0 = __nextBookmark.variables[__ignored0Ref] = __prevBookmark.variables[__ignored0Ref];
          var __exceptionToThrow = __prevBookmark.variables["__exceptionToThrow"];
          value = __nextBookmark.variables[__valueRef] = __prevBookmark.variables[__valueRef];
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
      __completer.completeError(__e, __s);
      return __completer.future;
    }
  }

  return _throwInMultipleWays(null, value);
}

/**
 * Test closures created within async functions.
 *
 *   async List nestedClosures(bool executeAwait) {
 *     var i = 0;
 *     var m = {};
 *     var closureForI = () => i;
 *     var closureForM = () => m;
 *     if (executeAwait) {
 *       <- wrapWithFuture(0);
 *     } else {
 *       (() => null)();
 *     }
 *     i = 2;
 *     m["a"] = 1;
 *     var closureForI2 = () => i;
 *     var closureForM2 = () => m;
 *     return [closureForI(), closureForI2(),
 *             closureForM(), closureForM2()];
 *   }
 */
Future<List> nestedClosures(bool executeAwait) {
  const __executeAwaitRef = ":executeAwait";

  Future<List> _nestedClosures(
      Bookmark __prevBookmark, bool executeAwait) {
    Bookmark __nextBookmark = new Bookmark<List>();
    if (__prevBookmark == null) {
      __nextBookmark.completer = new Completer<List>();
    } else {
      __nextBookmark.completer = __prevBookmark.completer;
    }
    Completer<List> __completer = __nextBookmark.completer;
    if (__prevBookmark == null) {
      __nextBookmark.variables[__executeAwaitRef] = executeAwait;
    }
    try {

      var i;
      const __iRef = ":i";
      if (__prevBookmark == null) {
        i = __nextBookmark.variables[__iRef] = 0;
      }

      var m;
      const __mRef = ":m";
      if (__prevBookmark == null) {
        m = __nextBookmark.variables[__mRef] = {};
      }

      var closureForI;
      const __closureForIRef = ":closureForI";
      if (__prevBookmark == null) {
        closureForI = __nextBookmark.variables[__closureForIRef] = () => i;
      }

      var closureForM;
      const __closureForMRef = ":closureForM";
      if (__prevBookmark == null) {
        closureForM = __nextBookmark.variables[__closureForMRef] = () => m;
      }

      if ((__prevBookmark == null && executeAwait) ||
          (__prevBookmark != null &&
          __prevBookmark.locations.contains("if0"))) {
        __nextBookmark.locations.add("if0");

        var __ignored0;
        const __ignored0Ref = "if0:__ignored0";
        if (__prevBookmark == null) {
          __reEnterFunction() {
            __nextBookmark.locations.add("await0");
            Bookmark __copy = new Bookmark.from(__nextBookmark);
            _nestedClosures(__copy, executeAwait);
          }

          wrapWithFuture(0).then((__value) {
            __nextBookmark.variables[__ignored0Ref] = __value;
            __reEnterFunction();
          }).catchError((__e) {
            __nextBookmark.variables["__exceptionToThrow"] = __e.error;
            __reEnterFunction();
            return true;
          });

          return __completer.future;
        }

        if (__prevBookmark.locations.contains("await0")) {
          executeAwait = __nextBookmark.variables[__executeAwaitRef] = __prevBookmark.variables[__executeAwaitRef];
          i = __nextBookmark.variables[__iRef] = __prevBookmark.variables[__iRef];
          m = __nextBookmark.variables[__mRef] = __prevBookmark.variables[__mRef];
          closureForI = __nextBookmark.variables[__closureForIRef] = __prevBookmark.variables[__closureForIRef];
          closureForM = __nextBookmark.variables[__closureForMRef] = __prevBookmark.variables[__closureForMRef];
          __ignored0 = __nextBookmark.variables[__ignored0Ref] = __prevBookmark.variables[__ignored0Ref];
          var __exceptionToThrow = __prevBookmark.variables["__exceptionToThrow"];
          __prevBookmark = null;

          if (__exceptionToThrow != null) throw __exceptionToThrow;
        }

        __nextBookmark.locations.remove("if0");
      }

      // I haven't written the transform for else yet, so I'm just going
      // to treat it as an if.
      if ((__prevBookmark == null && !executeAwait) ||
          (__prevBookmark != null &&
          __prevBookmark.locations.contains("if1"))) {
        __nextBookmark.locations.add("if1");

        if (__prevBookmark == null) {
          (() => null)();
        }

        __nextBookmark.locations.remove("if1");
      }

      if (__prevBookmark == null) {
        i = __nextBookmark.variables[__iRef] = 2;
      }

      if (__prevBookmark == null) {
        m["a"] = 1;
      }

      var closureForI2;
      const __closureForI2Ref = ":closureForI2";
      if (__prevBookmark == null) {
        closureForI2 = __nextBookmark.variables[__closureForI2Ref] = () => i;
      }

      var closureForM2;
      const __closureForM2Ref = ":closureForM2";
      if (__prevBookmark == null) {
        closureForM2 = __nextBookmark.variables[__closureForM2Ref] = () => m;
      }

      __completer.complete([closureForI(), closureForI2(),
                            closureForM(), closureForM2()]);
      return __completer.future;

    } catch (__e, __s) {
      __completer.completeError(__e, __s);
      return __completer.future;
    }
  }

  return _nestedClosures(null, executeAwait);
}