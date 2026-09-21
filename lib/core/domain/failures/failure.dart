sealed class Failure {
  const Failure(this.message);
  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Check your connection and try again.',
  ]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Please sign in to continue.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([
    super.message = 'Please check the details and try again.',
  ]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'This item is not available.']);
}

class ConflictFailure extends Failure {
  const ConflictFailure([
    super.message = 'This action could not be completed.',
  ]);
}

class RateLimitedFailure extends Failure {
  const RateLimitedFailure([
    super.message = 'Please wait before trying again.',
  ]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}
