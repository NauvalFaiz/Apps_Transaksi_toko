class Validator {

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return "Email wajib diisi";
    }

    if (!value.contains('@')) {
      return "Format email tidak valid";
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password harus diisi";
    }

    if (value.length < 6) {
      return "Password minimal 6 karakter";
    }

    return null;
  }
}