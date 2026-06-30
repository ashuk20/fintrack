import 'package:fintrack/features/transactions/presentation/bloc/add_transaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddTransactionBloc(),
      child: const _AddTransactionView(),
    );
  }
}

class _AddTransactionView extends StatefulWidget {
  const _AddTransactionView();

  @override
  State<_AddTransactionView> createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<_AddTransactionView> {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddTransactionBloc, AddTransactionState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AddTransactionStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transaction saved successfully !'),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );
          context.go('/dashboard');
        }

        if (state.status == AddTransactionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Something went wrong!'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: BlocBuilder<AddTransactionBloc, AddTransactionState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFF0A1628),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildTopBar(context),
                    const SizedBox(height: 20),
                    _buildToggle(context, state),
                    const SizedBox(height: 24),
                    _buildAmountInput(context, state),
                    const SizedBox(height: 24),
                    _buildTitleField(context, state),
                    const SizedBox(height: 20),
                    _buildCategoryPicker(context, state),
                    const SizedBox(height: 20),
                    _buildDatePicker(context, state),
                    const SizedBox(height: 32),
                    _buildSaveButton(context, state),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go('/dashboard'),
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFFD4AF37),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Add Transaction',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildToggle(BuildContext context, AddTransactionState state) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => context.read<AddTransactionBloc>().add(
                AddTransactionTypeChanged(false),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: !state.isIncome
                      ? const Color(0xFFef5350)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Expense',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !state.isIncome
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => context.read<AddTransactionBloc>().add(
                AddTransactionTypeChanged(true),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: state.isIncome
                      ? const Color(0xFF4CAF50)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Income',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: state.isIncome
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput(BuildContext context, AddTransactionState state) {
    return Center(
      child: Column(
        children: [
          Text(
            'Enter Amount',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 11,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: state.activeColor,
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: TextStyle(
                color: state.activeColor.withOpacity(0.3),
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
              prefixText: '₹ ',
              prefixStyle: TextStyle(
                color: state.activeColor,
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            onChanged: (value) => context.read<AddTransactionBloc>().add(
              AddTransactionAmountChanged(value),
            ),
          ),
          Container(
            height: 1.5,
            width: 160,
            color: state.activeColor.withOpacity(0.4),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField(BuildContext context, AddTransactionState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 11,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'e.g. Groceries from D-Mart',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.25),
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.06),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: state.activeColor, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onChanged: (value) => context.read<AddTransactionBloc>().add(
            AddTransactionTitleChanged(value),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryPicker(BuildContext context, AddTransactionState state) {
    final categories = [
      {
        'name': 'Shopping',
        'icon': Icons.shopping_cart_rounded,
        'color': Color(0xFF9C27B0),
      },
      {
        'name': 'Food',
        'icon': Icons.restaurant_rounded,
        'color': Color(0xFFFF9800),
      },
      {
        'name': 'Transport',
        'icon': Icons.directions_car_rounded,
        'color': Color(0xFF2196F3),
      },
      {'name': 'Bills', 'icon': Icons.bolt_rounded, 'color': Color(0xFFFFC107)},
      {
        'name': 'Health',
        'icon': Icons.medical_services_rounded,
        'color': Color(0xFFE91E63),
      },
      {
        'name': 'Entertainment',
        'icon': Icons.movie_rounded,
        'color': Color(0xFF673AB7),
      },
      {
        'name': 'Salary',
        'icon': Icons.account_balance_wallet_rounded,
        'color': Color(0xFF4CAF50),
      },
      {
        'name': 'Other',
        'icon': Icons.category_rounded,
        'color': Color(0xFF607D8B),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 11,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isSelected = state.category == cat['name'];
            final catColor = cat['color'] as Color;

            return GestureDetector(
              onTap: () => context.read<AddTransactionBloc>().add(
                AddTransactionCategoryChanged(cat['name'] as String),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? catColor.withOpacity(0.15)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? catColor : Colors.transparent,
                    width: 1.5,
                  ),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      cat['icon'] as IconData,
                      color: isSelected
                          ? catColor
                          : Colors.white.withOpacity(0.4),
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cat['name'] as String,
                      style: TextStyle(
                        color: isSelected
                            ? catColor
                            : Colors.white.withOpacity(0.4),
                        fontSize: 9,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, AddTransactionState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 11,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: Color(0xFFD4AF37),
                      onPrimary: Color(0xFF0A1628),
                      surface: Color(0xFF1a3a5c),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (picked != null && context.mounted) {
              context.read<AddTransactionBloc>().add(
                AddTransactionDateChanged(picked),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM d, yyyy').format(state.date),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                Icon(
                  Icons.calendar_today_rounded,
                  color: const Color(0xFFD4AF37),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, AddTransactionState state) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: state.status == AddTransactionStatus.loading
            ? null
            : () => context.read<AddTransactionBloc>().add(
                AddTransactionSubmitted(),
              ),
        style: ElevatedButton.styleFrom(
          backgroundColor: state.activeColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: state.activeColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: state.status == AddTransactionStatus.loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Save Transaction',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
