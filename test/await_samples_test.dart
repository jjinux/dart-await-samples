import 'package:unittest/unittest.dart';
import 'package:dart_await_samples/await_samples.dart';

void main() {
  group('await_samples', () {
    test("asyncIncrement", () {
      var checkResult = expectAsync1((value) => expect(value, 1));
      asyncIncrement(0).then(checkResult);
    });
    
    test("asyncThrow", () {
      var handleException = expectAsync1((e) {
        assert(e is SomeException);
        expect(e.message, "Expected");
      });
      asyncThrow(new SomeException("Expected")).handleException(handleException);
    });
 
    test("wrapWithFuture", () {
      var checkResult = expectAsync1((value) => expect(value, 0));
      wrapWithFuture(0).then(checkResult);
    });
    
    test("simpleStatement", () {
      var checkResult = expectAsync1((value) => expect(value, 2));
      simpleStatement(0).then(checkResult);
    });
    
    test("whileLoop", () {
      var checkResult = expectAsync1((value) => expect(value, 3 + 2 + 1));
      whileLoop(3).then(checkResult);
    });
    
    test("recursivelySum", () {
      var checkResult = expectAsync1((value) => expect(value, 3 + 2 + 1));
      recursivelySum(3).then(checkResult);
    });
    
    group('throwInMultipleWays', () {
      test("Handles exceptions before <-", () {
        var handleException = expectAsync1((e) {
          assert(e is SomeException);
          expect(e.message, "Throw before <-");
        });
        throwInMultipleWays(0).handleException(handleException);
      });

      test("Handles exceptions in function called with <-", () {
        var handleException = expectAsync1((e) {
          assert(e is SomeException);
          expect(e.message, "Throw during <-");
        });
        throwInMultipleWays(1).handleException(handleException);
      });

      test("Handles exceptions after <-", () {
        var handleException = expectAsync1((e) {
          assert(e is SomeException);
          expect(e.message, "Throw after <-");
        });
        throwInMultipleWays(2).handleException(handleException);
      });
    });
  });
}