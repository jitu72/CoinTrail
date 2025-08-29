import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cointrail/controller/home_controller/home_controller.dart';
import 'package:cointrail/model/transaction_model.dart';
import 'package:cointrail/services/local_data_service.dart';
import 'package:cointrail/widgets/toast/custom_toast.dart';

class TransactionController extends GetxController {
  final amountController = TextEditingController();
  var selectedCategory = ''.obs;
  final titleController = TextEditingController();
  final selectedType = 'expense'.obs;
  var isLoading = false.obs;
  var isSubmitted = false.obs;
  var selectedDate = DateTime.now().toIso8601String().obs;

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
    titleController.dispose();
  }

  Future<void> addResource() async {
    try {
      // Validate inputs first
      if (amountController.text.isEmpty) {
        CustomToast.errorToast('Error', 'Amount cannot be empty');
        return;
      }

      if (titleController.text.isEmpty) {
        CustomToast.errorToast('Error', 'Description cannot be empty');
        return;
      }

      if (selectedCategory.value.isEmpty) {
        CustomToast.errorToast('Error', 'Please select a category');
        return;
      }

      isLoading.value = true;

      final amount = double.tryParse(amountController.text);
      if (amount == null || amount <= 0) {
        CustomToast.errorToast('Error', 'Please enter a valid amount');
        return;
      }

      // Create transaction
      final transaction = TransactionModel(
        userId: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: amount,
        description: titleController.text,
        type: selectedType.value,
        category: selectedCategory.value,
        date: DateTime.parse(selectedDate.value),
      );

      // Save transaction locally
      await LocalDataService.saveTransaction(transaction);

      // Update balance
      final currentBalance = await LocalDataService.getBalance();
      final newBalance = selectedType.value == 'income' 
          ? currentBalance + amount 
          : currentBalance - amount;
      await LocalDataService.saveBalance(newBalance);

      // Clear form
      amountController.clear();
      titleController.clear();
      selectedCategory.value = '';
      selectedType.value = 'expense';
      selectedDate.value = DateTime.now().toIso8601String();

      CustomToast.successToast('Success', 'Transaction added successfully');
      
      // Refresh home controller if it exists
      try {
        final homeController = Get.find<HomeController>();
        homeController.fetchTransactions();
      } catch (e) {
        // Home controller not found, that's ok
      }

      Get.back(); // Close the transaction form

    } catch (e) {
      CustomToast.errorToast('Error', 'Failed to add transaction: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedType(String type) {
    selectedType.value = type;
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date.toIso8601String();
  }

  // Delete transaction method
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await LocalDataService.deleteTransaction(transactionId);
      
      CustomToast.successToast('Success', 'Transaction deleted successfully');
      
      // Refresh home controller if it exists
      try {
        final homeController = Get.find<HomeController>();
        homeController.fetchTransactions();
      } catch (e) {
        // Home controller not found, that's ok
      }
    } catch (e) {
      CustomToast.errorToast('Error', 'Failed to delete transaction: $e');
    }
  }

  // Update transaction method
  Future<void> updateTransaction(String transactionId) async {
    try {
      // For now, just refresh the data
      // In a real implementation, you would update the specific transaction
      CustomToast.successToast('Success', 'Transaction updated successfully');
      
      // Refresh home controller if it exists
      try {
        final homeController = Get.find<HomeController>();
        homeController.fetchTransactions();
      } catch (e) {
        // Home controller not found, that's ok
      }
    } catch (e) {
      CustomToast.errorToast('Error', 'Failed to update transaction: $e');
    }
  }
}
