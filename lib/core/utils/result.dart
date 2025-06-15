// Custom Result type to replace dartz Either
abstract class Result<L, R> {
  const Result();
  
  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;
  
  L get left => (this as Left<L, R>).value;
  R get right => (this as Right<L, R>).value;
  
  T fold<T>(T Function(L) leftFunction, T Function(R) rightFunction) {
    if (isLeft) {
      return leftFunction(left);
    } else {
      return rightFunction(right);
    }
  }
}

class Left<L, R> extends Result<L, R> {
  final L value;
  const Left(this.value);
}

class Right<L, R> extends Result<L, R> {
  final R value;
  const Right(this.value);
}