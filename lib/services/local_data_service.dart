import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cointrail/model/transaction_model.dart';

class LocalDataService {
  static const String _transactionsKey = 'transactions';
  static const String _balanceKey = 'balance';
  static const String _userNameKey = 'userName';
  static const String _userEmailKey = 'userEmail';

  // Get SharedPreferences instance
  static Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  // User Balance Methods
  static Future<void> saveBalance(double balance) async {
    final prefs = await _prefs;
    await prefs.setDouble(_balanceKey, balance);
  }

  static Future<double> getBalance() async {
    final prefs = await _prefs;
    return prefs.getDouble(_balanceKey) ?? 0.0;
  }

  // User Name Methods
  static Future<void> saveUserName(String name) async {
    final prefs = await _prefs;
    await prefs.setString(_userNameKey, name);
  }

  static Future<String> getUserName() async {
    final prefs = await _prefs;
    return prefs.getString(_userNameKey) ?? 'User';
  }

  // User Email Methods
  static Future<void> saveUserEmail(String email) async {
    final prefs = await _prefs;
    await prefs.setString(_userEmailKey, email);
  }

  static Future<String> getUserEmail() async {
    final prefs = await _prefs;
    return prefs.getString(_userEmailKey) ?? 'guest@example.com';
  }

  // Transaction Methods
  static Future<void> saveTransaction(TransactionModel transaction) async {
    final transactions = await getTransactions();
    transactions.add(transaction);
    await _saveTransactions(transactions);
  }

  static Future<void> saveTransactions(List<TransactionModel> transactions) async {
    await _saveTransactions(transactions);
  }

  static Future<void> _saveTransactions(List<TransactionModel> transactions) async {
    final prefs = await _prefs;
    final transactionsJson = transactions.map((t) => t.toJson()).toList();
    await prefs.setString(_transactionsKey, jsonEncode(transactionsJson));
  }

  static Future<List<TransactionModel>> getTransactions() async {
    final prefs = await _prefs;
    final transactionsString = prefs.getString(_transactionsKey);
    
    if (transactionsString == null) return [];
    
    final List<dynamic> transactionsJson = jsonDecode(transactionsString);
    return transactionsJson.map((json) => TransactionModel.fromJson(json)).toList();
  }

  static Future<void> deleteTransaction(String transactionId) async {
    final transactions = await getTransactions();
    transactions.removeWhere((t) => t.userId == transactionId);
    await _saveTransactions(transactions);
  }

  static Future<void> updateTransaction(TransactionModel updatedTransaction) async {
    final transactions = await getTransactions();
    final index = transactions.indexWhere((t) => t.userId == updatedTransaction.userId);
    if (index != -1) {
      transactions[index] = updatedTransaction;
      await _saveTransactions(transactions);
    }
  }

  // Clear all data (useful for testing)
  static Future<void> clearAllData() async {
    final prefs = await _prefs;
    await prefs.clear();
  }

  // Initialize with sample data (optional)
  static Future<void> initializeSampleData() async {
    final transactions = await getTransactions();
    if (transactions.isEmpty) {
      // Add some sample transactions
      final sampleTransactions = [
        TransactionModel(
          userId: DateTime.now().millisecondsSinceEpoch.toString(),
          description: 'Weekly grocery shopping',
          amount: 50.0,
          type: 'expense',
          category: 'Food',
          date: DateTime.now(),
        ),
        TransactionModel(
          userId: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          description: 'Monthly salary',
          amount: 2000.0,
          type: 'income',
          category: 'Work',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
      await saveTransactions(sampleTransactions);
      await saveBalance(1950.0); // Starting balance after sample transactions
      await saveUserName('Guest User');
    }
  }
}
