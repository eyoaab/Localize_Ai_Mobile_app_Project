abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => 'Failure: $message';
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}


class ConnectionFailure extends Failure {
  const ConnectionFailure(String message) : super(message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(String message) : super(message);
}

