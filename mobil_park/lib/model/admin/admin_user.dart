class UserModel {
  String name;
  String phoneNo;
  String email;
  String password;

  UserModel({
    required this.name,
    required this.phoneNo,
    required this.email,
    required this.password,
  });

  // Validation method
  bool isValid() {
    return name.isNotEmpty && phoneNo.isNotEmpty && email.isNotEmpty && password.isNotEmpty;
  }

  // Convert UserModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone_no': phoneNo,
      'email': email,
    };
  }
}