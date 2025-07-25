import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spendify/model/transaction_model.dart';
import 'package:spendify/services/local_data_service.dart';

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
      totalBalance.value = await LocalDataService.getBalance();
      userEmail.value = 'guest@local.app';
    } catch (e) {
      developer.log('Error loading user data: $e', name: 'HomeControllerSimple');
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
      developer.log('Error fetching transactions: $e', name: 'HomeControllerSimple');
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
}
