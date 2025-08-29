import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cointrail/model/transaction_model.dart';
import 'package:cointrail/services/local_data_service.dart';

class HomeController extends GetxController {
  var userEmail = 'guest@example.com'.obs;
  var userName = 'Guest User'.obs;
  var totalBalance = 0.0.obs;
  var imageUrl = ''.obs;
  var transactions = <Map<String, dynamic>>[].obs;
  var transactionsList = <TransactionModel>[].obs;

  var isLoading = false.obs;
  var totalExpense = 0.0.obs;
  var totalIncome = 0.0.obs;
  var selectedFilter = 'weekly'.obs;

  var selectedChip = ''.obs;
  var isSelected = false.obs;
  List<Map<String, dynamic>> chartData = [];

  // pagination variables
  var currentPage = 1;
  var itemsPerPage = 10;

  var groupedTransactions = <String, List<Map<String, dynamic>>>{}.obs;
  var limit = 10.obs;
  var selectedYear = DateTime.now().year.obs;

  RxBool isAmountVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchTransactions();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    try {
      userName.value = await LocalDataService.getUserName();
      userEmail.value = await LocalDataService.getUserEmail();
      totalBalance.value = await LocalDataService.getBalance();
    } catch (e) {
      developer.log('Error loading user data: $e', name: 'HomeController');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTransactions() async {
    isLoading.value = true;
    try {
      transactionsList.value = await LocalDataService.getTransactions();
      
      // Convert to Map format for compatibility
      transactions.value = transactionsList.map((transaction) => {
        'id': transaction.userId,
        'amount': transaction.amount,
        'description': transaction.description,
        'type': transaction.type,
        'category': transaction.category,
        'date': transaction.date.toIso8601String(),
      }).toList();

      calculateTotals();
      groupTransactionsByDate();
    } catch (e) {
      developer.log('Error fetching transactions: $e', name: 'HomeController');
    } finally {
      isLoading.value = false;
    }
  }

  void calculateTotals() {
    totalIncome.value = transactionsList
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
        
    totalExpense.value = transactionsList
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  void groupTransactionsByDate() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    
    for (var transaction in transactions) {
      final date = DateTime.parse(transaction['date']);
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(transaction);
    }
    
    groupedTransactions.value = grouped;
  }

  Future<void> signOut() async {
    // For local version, just show a message
    Get.snackbar('Info', 'This is the local version - no authentication required');
  }

  Future<void> updateUserInfo(String name, String email) async {
    try {
      developer.log('Starting updateUserInfo: name=$name, email=$email', name: 'HomeController');
      
      userName.value = name;
      userEmail.value = email;
      
      developer.log('Updated observable values: userName=${userName.value}, userEmail=${userEmail.value}', name: 'HomeController');
      
      // Save to local storage
      await LocalDataService.saveUserName(name);
      await LocalDataService.saveUserEmail(email);
      
      developer.log('User info updated successfully in local storage', name: 'HomeController');
    } catch (e) {
      developer.log('Error updating user info: $e', name: 'HomeController');
      Get.snackbar(
        'Error', 
        'Failed to update user information',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  void toggleAmountVisibility() {
    isAmountVisible.value = !isAmountVisible.value;
  }

  void changeSelectedFilter(String filter) {
    selectedFilter.value = filter;
    // You can add filtering logic here if needed
  }

  void changeSelectedChip(String chip) {
    selectedChip.value = chip;
  }

  List<Map<String, dynamic>> getRecentTransactions() {
    final sortedTransactions = List<Map<String, dynamic>>.from(transactions);
    sortedTransactions.sort((a, b) => 
        DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
    return sortedTransactions.take(10).toList();
  }

  Map<String, double> getExpensesByCategory() {
    final expenseTransactions = transactionsList.where((t) => t.type == 'expense');
    final categoryMap = <String, double>{};
    
    for (var transaction in expenseTransactions) {
      categoryMap[transaction.category] = 
          (categoryMap[transaction.category] ?? 0.0) + transaction.amount;
    }
    
    return categoryMap;
  }

  // Filter transactions based on the selected filter and year
  void filterTransactions(String filter) {
    selectedFilter.value = filter;
    // For now, just refresh the data
    fetchTransactions();
  }

  // Calculate monthly totals for chart display
  Map<String, Map<String, double>> calculateMonthlyTotals() {
    final monthlyTotals = <String, Map<String, double>>{};
    
    for (var transaction in transactionsList) {
      if (transaction.date.year == selectedYear.value) {
        final monthKey = DateFormat('MMM').format(transaction.date);
        
        if (!monthlyTotals.containsKey(monthKey)) {
          monthlyTotals[monthKey] = {
            'income': 0.0,
            'expense': 0.0,
            'savings': 0.0,
          };
        }
        
        if (transaction.type == 'income') {
          monthlyTotals[monthKey]!['income'] = 
              (monthlyTotals[monthKey]!['income'] ?? 0.0) + transaction.amount;
        } else if (transaction.type == 'expense') {
          monthlyTotals[monthKey]!['expense'] = 
              (monthlyTotals[monthKey]!['expense'] ?? 0.0) + transaction.amount;
        }
        
        // Calculate savings
        monthlyTotals[monthKey]!['savings'] = 
            (monthlyTotals[monthKey]!['income'] ?? 0.0) - 
            (monthlyTotals[monthKey]!['expense'] ?? 0.0);
      }
    }
    
    return monthlyTotals;
  }

  // Calculate savings change (dummy implementation)
  double calculateSavingsChange() {
    // Simple calculation: income - expenses as percentage
    final currentSavings = totalIncome.value - totalExpense.value;
    final savingsRate = totalIncome.value > 0 ? (currentSavings / totalIncome.value) * 100 : 0.0;
    return savingsRate;
  }

  // Toggle visibility (alias for toggleAmountVisibility)
  void toggleVisibility() {
    toggleAmountVisibility();
  }

  // Calculate income change (dummy implementation)
  double calculateIncomeChange() {
    // Simple implementation: return a positive percentage
    return 5.0; // 5% increase
  }

  // Calculate expense change (dummy implementation)  
  double calculateExpenseChange() {
    // Simple implementation: return a negative percentage (good thing)
    return -3.0; // 3% decrease
  }

  // Calculate totals by category
  Map<String, double> calculateTotalsByCategory() {
    return getExpensesByCategory();
  }

  // Get category icon (return IconData instead of String)
  IconData getCategoryIcon(String category, List<dynamic> categoryList) {
    // Return a default icon - you can customize this based on category
    switch (category.toLowerCase()) {
      case 'food':
      case 'groceries':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'health':
        return Icons.local_hospital;
      case 'work':
      case 'income':
        return Icons.work;
      default:
        return Icons.category;
    }
  }

  // Get transactions (alias for fetchTransactions)
  Future<void> getTransactions() async {
    await fetchTransactions();
  }

  // Update transaction (dummy implementation)
  Future<void> updateTransaction(String transactionId) async {
    // In a real implementation, this would update a specific transaction
    // For now, just refresh the data
    await fetchTransactions();
  }

  // Load more transactions (pagination)
  void loadMore() {
    // For now, just increase the limit
    limit.value += 10;
    fetchTransactions();
  }

  // Format date time for display
  String formatDateTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  // Add filteredTransactions getter
  List<Map<String, dynamic>> get filteredTransactions {
    return transactions;
  }
}
