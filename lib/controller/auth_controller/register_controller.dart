import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cointrail/widgets/bottom_navigation.dart';
import 'package:cointrail/widgets/toast/custom_toast.dart';
import 'package:cointrail/services/local_data_service.dart';

class RegisterController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  var balanceKeypad = TextEditingController();

  var emailC = TextEditingController();
  var passwordC = TextEditingController();
  var nameC = TextEditingController();
  var imageUrl = ''.obs;
  RxString selectedAvatarUrl = ''.obs;
  List<String> avatarList = [
    'https://avatar.iran.liara.run/public/boy?username=boy1',
    'https://avatar.iran.liara.run/public/girl?username=girl1',
    'https://avatar.iran.liara.run/public/boy?username=boy2',
    'https://avatar.iran.liara.run/public/girl?username=girl2',
  ];

  void toggleVisibility() {
    isHidden.value = !isHidden.value;
  }

  void setSelectedAvatar(String avatarUrl) {
    selectedAvatarUrl.value = avatarUrl;
  }

  var selectedImagePath = ''.obs;

  void setImagePath(String path) {
    selectedImagePath.value = path;
  }

  // Dummy register function for local version
  Future<void> registerUser() async {
    if (nameC.text.isEmpty || emailC.text.isEmpty || passwordC.text.isEmpty) {
      CustomToast.errorToast('Error', 'Please fill in all fields');
      return;
    }

    isLoading.value = true;

    try {
      // For local version, just save the user data locally
      await LocalDataService.saveUserName(nameC.text);
      
      // Set initial balance if provided
      if (balanceKeypad.text.isNotEmpty) {
        final balance = double.tryParse(balanceKeypad.text) ?? 0.0;
        await LocalDataService.saveBalance(balance);
      }

      CustomToast.successToast('Success', 'Account created successfully!');
      
      // Navigate to home
      Get.offAll(const BottomNav());
      
    } catch (e) {
      CustomToast.errorToast('Error', 'Failed to create account: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    nameC.dispose();
    balanceKeypad.dispose();
    super.dispose();
  }

  // Add alias method for register
  Future<void> register() async {
    await registerUser();
  }
}
