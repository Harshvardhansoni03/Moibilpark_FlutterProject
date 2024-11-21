import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isPasswordVisible = false.obs;
  var name = ''.obs;
  var phone = ''.obs;
  var confirmPassword = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() {
    // Add login logic here
    if (email.value.isNotEmpty && password.value.isNotEmpty) {
      print("Logging in with email: ${email.value}");
    } else {
      Get.snackbar("Error", "Please fill in all fields");
    }
  }

  void signup() {
    // Add signup logic here
    if (name.value.isNotEmpty &&
        phone.value.isNotEmpty &&
        email.value.isNotEmpty &&
        password.value == confirmPassword.value) {
      print("Signing up user: ${name.value}");
    } else {
      Get.snackbar("Error", "Please ensure all fields are correctly filled");
    }
  }
}
