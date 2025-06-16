class AppFailure {
  final String message;
  AppFailure([this.message = 'Sorry , Unexpected error occur! ']);

  @override
  String toString() {
    return 'AppFailure{message: $message}';
  }
}
