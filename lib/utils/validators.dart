class Validators {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Please enter your email';
    }
    if (!_emailPattern.hasMatch(text)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  static String? required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $label';
    }
    return null;
  }

  static String? positiveInt(String? value) {
    final number = int.tryParse(value?.trim() ?? '');
    if (number == null || number < 1) {
      return 'Please enter a whole number of at least 1';
    }
    return null;
  }

  static String? positiveNumber(String? value) {
    final number = double.tryParse(value?.trim() ?? '');
    if (number == null || number <= 0) {
      return 'Please enter a number greater than 0';
    }
    return null;
  }
}
