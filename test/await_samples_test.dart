import 'package:unittest/unittest.dart';
import 'package:dart_await_samples/await_samples.dart';

void main() {
  group('await_samples', () {
    test("incrementSlowly", () {
      var checkResult = expectAsync1((value) => expect(value, 1));
      incrementSlowly(0).then(checkResult);
    });
    
    test("wrapWithFuture", () {
      var checkResult = expectAsync1((value) => expect(value, 0));
      wrapWithFuture(0).then(checkResult);
    });
    
    test("simpleStatement", () {
      var checkResult = expectAsync1((value) => expect(value, 2));
      simpleStatement(0).then(checkResult);
    });
  });
}