import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expenzo/widgets/bottom_navigation.dart';
import 'package:expenzo/widgets/toast/custom_toast.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  var emailC = TextEditingController();
  var passwordC = TextEditingController();
  
  @override
  void dispose() {
    super.dispose();
    emailC.dispose();
    passwordC.dispose();
  }

  void toggleVisibility() {
    isHidden.value = !isHidden.value;
  }

  Future<bool?> login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      isLoading.value = true;
      
      try {
        // For local version, just simulate login and go to home
        await Future.delayed(const Duration(seconds: 1)); // Simulate loading
        
        CustomToast.successToast('Success', 'Logged in successfully!');
        isLoading.value = false;
        Get.offAll(const BottomNav());
        
        return true;
      } catch (e) {
        CustomToast.errorToast('Error', 'Failed to login: $e');
        isLoading.value = false;
        return false;
      }
    } else {
      CustomToast.errorToast('Error', 'Please fill in all fields');
      return false;
    }
  }
}
