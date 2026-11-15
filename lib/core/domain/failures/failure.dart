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

/// Raised when a feature is intentionally unavailable in this build — e.g. a
/// release build without the demo flag where there is no real backend wired in
/// yet. Lets the UI show a neutral "service unavailable / not configured"
/// state instead of a working bypass.
class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure([
    super.message = 'This service is not available right now.',
  ]);
}
