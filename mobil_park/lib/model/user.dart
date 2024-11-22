// model/user.dart
class UserModel {
  String name;
  String phone;
  String email;
  String password;
  String confirmPassword;
  String carNumber;
  String facultyEmploymentNumber;

  UserModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.carNumber,
    required this.facultyEmploymentNumber,
  });

  // Validate the fields
  bool isValid() {
    if (name.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || carNumber.isEmpty || facultyEmploymentNumber.isEmpty) {
      return false;
    }
    if (password != confirmPassword) return false;
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) return false;
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) return false;
    return true;
  }

  // Optionally, add methods to handle Firebase interactions here
}
