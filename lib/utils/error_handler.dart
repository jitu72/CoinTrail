import 'package:flutter/foundation.dart';

class ErrorHandler {
  static void handleError(dynamic error, {String? context}) {
    String message = 'An unexpected error occurred';
    
    if (error is Exception) {
      message = error.toString().replaceAll('Exception: ', '');
    } else if (error is String) {
      message = error;
    }
    
    // Log error for debugging (only in debug mode)
    if (kDebugMode) {
      debugPrint('Error${context != null ? ' in $context' : ''}: $message');
    }
  }
  
  static void handleSuccess(String message) {
    if (kDebugMode) {
      debugPrint('Success: $message');
    }
  }
  
  static void handleInfo(String title, String message) {
    if (kDebugMode) {
      debugPrint('Info - $title: $message');
    }
  }
  
  static String getUserFriendlyMessage(dynamic error) {
    if (error.toString().contains('network')) {
      return 'Please check your internet connection';
    } else if (error.toString().contains('timeout')) {
      return 'Request timed out. Please try again';
    } else if (error.toString().contains('permission')) {
      return 'Permission denied. Please check app permissions';
    }
    return 'Something went wrong. Please try again';
  }
}
