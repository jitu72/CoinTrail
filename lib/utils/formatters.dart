import 'package:intl/intl.dart';

class CurrencyFormatter {
  static const String defaultCurrency = 'USD';
  static const String defaultSymbol = '\$';
  static const String defaultLocale = 'en_US';

  static String formatCurrency(double amount, {
    String? currency,
    String? symbol,
    String? locale,
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale ?? defaultLocale,
      symbol: symbol ?? defaultSymbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  static String formatAmount(double amount, {
    int decimalDigits = 2,
    bool showSymbol = true,
  }) {
    if (showSymbol) {
      return formatCurrency(amount, decimalDigits: decimalDigits);
    } else {
      final formatter = NumberFormat.decimalPattern();
      return formatter.format(amount);
    }
  }

  static String formatCompactCurrency(double amount, {
    String? symbol,
    String? locale,
  }) {
    final formatter = NumberFormat.compactCurrency(
      locale: locale ?? defaultLocale,
      symbol: symbol ?? defaultSymbol,
    );
    return formatter.format(amount);
  }

  static String formatWithCommas(double amount) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(amount);
  }

  static double parseAmount(String amountString) {
    final cleanedString = amountString.replaceAll(RegExp(r'[^\d.-]'), '');
    return double.tryParse(cleanedString) ?? 0.0;
  }

  static String getAmountColor(double amount, {
    bool isExpense = true,
  }) {
    if (amount == 0) return 'neutral';
    if (isExpense) {
      return amount > 0 ? 'negative' : 'positive';
    } else {
      return amount > 0 ? 'positive' : 'negative';
    }
  }

  static String formatPercentage(double percentage, {
    int decimalDigits = 1,
  }) {
    final formatter = NumberFormat.percentPattern();
    return formatter.format(percentage / 100);
  }
}

class DateFormatter {
  static String formatDate(DateTime date, {
    String pattern = 'MMM dd, yyyy',
  }) {
    final formatter = DateFormat(pattern);
    return formatter.format(date);
  }

  static String formatTime(DateTime date, {
    String pattern = 'hh:mm a',
  }) {
    final formatter = DateFormat(pattern);
    return formatter.format(date);
  }

  static String formatDateTime(DateTime date, {
    String pattern = 'MMM dd, yyyy hh:mm a',
  }) {
    final formatter = DateFormat(pattern);
    return formatter.format(date);
  }

  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return formatDate(date);
      }
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  static String getMonthYear(DateTime date) {
    final formatter = DateFormat('MMMM yyyy');
    return formatter.format(date);
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }
}

class StringUtils {
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String capitalizeWords(String text) {
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPhoneNumber(String phone) {
    return RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(phone);
  }

  static String removeSpecialCharacters(String text) {
    return text.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
  }
}
