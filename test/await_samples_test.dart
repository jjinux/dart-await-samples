import 'package:unittest/unittest.dart';
import 'package:dart_await_samples/await_samples.dart';

void main() {
  group('await_samples', () {
    test("asyncIncrement", () {
      var checkResult = expectAsync1((value) => expect(value, 1));
      asyncIncrement(0).then(checkResult);
    });

    test("asyncThrow", () {
      var catchError = expectAsync1((e) {        
        assert(e.error is SomeException);
        expect(e.error.message, "Expected");
      });
      asyncThrow(new SomeException("Expected")).catchError(catchError);
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
        var catchError = expectAsync1((e) {
          assert(e.error is SomeException);
          expect(e.error.message, "Throw before <-");
        });
        throwInMultipleWays(0).catchError(catchError);
      });

      test("Handles exceptions in function called with <-", () {
        var catchError = expectAsync1((e) {
          assert(e.error is SomeException);
          expect(e.error.message, "Throw during <-");
        });
        throwInMultipleWays(1).catchError(catchError);
      });

      test("Handles exceptions after <-", () {
        var catchError = expectAsync1((e) {
          assert(e.error is SomeException);
          expect(e.error.message, "Throw after <-");
        });
        throwInMultipleWays(2).catchError(catchError);
      });
    });

    group('nestedClosures', () {
      test("when executeAwait is false, closureForI() == closureForI2()", () {
        var checkResult = expectAsync1((value) => expect(value, [2, 2, {'a': 1}, {'a': 1}]));
        nestedClosures(false).then(checkResult);
      });

      test("when executeAwait is true, closureForI() != closureForI2()", () {
        var checkResult = expectAsync1((value) => expect(value, [0, 2, {'a': 1}, {'a': 1}]));
        nestedClosures(true).then(checkResult);
      });
    });
  });
}