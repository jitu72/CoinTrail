import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cointrail/widgets/enhanced_text_field.dart';
import 'package:cointrail/widgets/loading_widgets.dart';
import 'package:cointrail/widgets/custom_cards.dart';
import 'package:cointrail/utils/formatters.dart';

class EnhancedTransactionForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final Map<String, dynamic>? initialData;
  final bool isEditing;

  const EnhancedTransactionForm({
    super.key,
    required this.onSubmit,
    this.initialData,
    this.isEditing = false,
  });

  @override
  State<EnhancedTransactionForm> createState() => _EnhancedTransactionFormState();
}

class _EnhancedTransactionFormState extends State<EnhancedTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  
  bool _isLoading = false;
  String _selectedType = 'expense';
  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();
  
  final List<String> _expenseCategories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Education',
    'Travel',
    'Other',
  ];
  
  final List<String> _incomeCategories = [
    'Salary',
    'Business',
    'Investment',
    'Freelance',
    'Gift',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _loadInitialData();
    } else {
      _selectedCategory = _expenseCategories.first;
    }
  }

  void _loadInitialData() {
    final data = widget.initialData!;
    _amountController.text = data['amount']?.toString() ?? '';
    _descriptionController.text = data['description'] ?? '';
    _notesController.text = data['notes'] ?? '';
    _selectedType = data['type'] ?? 'expense';
    _selectedCategory = data['category'] ?? _expenseCategories.first;
    _selectedDate = DateTime.tryParse(data['date'] ?? '') ?? DateTime.now();
  }

  List<String> get _currentCategories {
    return _selectedType == 'expense' ? _expenseCategories : _incomeCategories;
  }

  void _updateCategoryOnTypeChange() {
    if (!_currentCategories.contains(_selectedCategory)) {
      _selectedCategory = _currentCategories.first;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      final transactionData = {
        'amount': amount,
        'description': _descriptionController.text.trim(),
        'notes': _notesController.text.trim(),
        'type': _selectedType,
        'category': _selectedCategory,
        'date': _selectedDate.toIso8601String(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      await widget.onSubmit(transactionData);
      
      if (!widget.isEditing && mounted) {
        // Reset form for new transactions
        _formKey.currentState!.reset();
        _amountController.clear();
        _descriptionController.clear();
        _notesController.clear();
        setState(() {
          _selectedDate = DateTime.now();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      message: widget.isEditing ? 'Updating transaction...' : 'Adding transaction...',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction Type Selection
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaction Type',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTypeOption('expense', 'Expense', Colors.red),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTypeOption('income', 'Income', Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Amount Field
            EnhancedTextField(
              label: 'Amount',
              hint: 'Enter amount',
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Icons.attach_money,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Amount is required';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid amount';
                }
                if (double.parse(value) <= 0) {
                  return 'Amount must be greater than zero';
                }
                return null;
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Category Selection
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _currentCategories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Category is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Description Field
            EnhancedTextField(
              label: 'Description',
              hint: 'Enter description',
              controller: _descriptionController,
              prefixIcon: Icons.description,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Date Selection
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 12),
                          Text(DateFormatter.formatDate(_selectedDate)),
                          const Spacer(),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Notes Field (Optional)
            EnhancedTextField(
              label: 'Notes (Optional)',
              hint: 'Add any additional notes',
              controller: _notesController,
              prefixIcon: Icons.note,
              maxLines: 3,
            ),
            
            const SizedBox(height: 24),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: LoadingButton(
                onPressed: _handleSubmit,
                text: widget.isEditing ? 'Update Transaction' : 'Add Transaction',
                isLoading: _isLoading,
                icon: widget.isEditing ? Icons.update : Icons.add,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeOption(String value, String label, Color color) {
    final isSelected = _selectedType == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = value;
          _updateCategoryOnTypeChange();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.grey.shade100,
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              value == 'expense' ? Icons.remove_circle : Icons.add_circle,
              color: isSelected ? color : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
