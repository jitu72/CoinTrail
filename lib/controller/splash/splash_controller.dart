import 'dart:async';
import 'package:get/get.dart';
import 'package:expenzo/widgets/bottom_navigation.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(seconds: 2), () => _navigateToHome());
  }

  Future<void> _navigateToHome() async {
    // For local version, always go directly to home
    Get.offAll(const BottomNav());
  }
}
