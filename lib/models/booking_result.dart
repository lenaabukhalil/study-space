class BookingResult {
  final bool success;
  final String? errorMessage;

  const BookingResult.success()
      : success = true,
        errorMessage = null;

  const BookingResult.failure(String message)
      : success = false,
        errorMessage = message;
}
