  import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
  import 'package:fintrack/features/transactions/presentation/bloc/transaction_bloc.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:go_router/go_router.dart';
  import 'package:intl/intl.dart';

  class TransactionScreen extends StatelessWidget {
    const TransactionScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return BlocProvider(
        create: (_) => TransactionBloc()..add(TransactionStarted()),
        child: const _TransactionView(),
      );
    }
  }

  class _TransactionView extends StatelessWidget {
    const _TransactionView({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A1628),
        body: SafeArea(
          child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        _buildTopBar(context),
                        SizedBox(height: 16),
                        _buildFilterChilps(context, state),
                        SizedBox(height: 14),
                        _buildSummaryRow(state),
                      ],
                    ),
                  ),
                  Expanded(child: _buildTransactionList(context, state)),
                ],
              );
            },
          ),
        ),
        // bottomNavigationBar: _buildBottomNav(context),
      );
    }

    Widget _buildTopBar(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Transactions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () => context.go('/add-transaction'),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Color(0xFF0A1628),
                size: 22,
              ),
            ),
          ),
        ],
      );
    }

    Widget _buildFilterChilps(BuildContext context, TransactionState state) {
      final filters = [
        {'label': 'All', 'filter': TransactionFilter.all},
        {'label': 'Income', 'filter': TransactionFilter.income},
        {'label': 'Expense', 'filter': TransactionFilter.expense},
        {'label': 'This Month', 'filter': TransactionFilter.thisMonth},
        {'label': 'Last Month', 'filter': TransactionFilter.lastMonth},
      ];
      return SizedBox(
        height: 34,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final item = filters[index];
            final isActive = state.activeFilter == item['filter'];
            return GestureDetector(
              onTap: () => context.read<TransactionBloc>().add(
                TransactionFilterChanged(item['filter'] as TransactionFilter),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFD4AF37)
                      : Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFFD4AF37)
                        : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Text(
                  item['label'] as String,
                  style: TextStyle(
                    color: isActive
                        ? const Color(0xFF0A1628)
                        : Colors.white.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemCount: filters.length,
        ),
      );
    }

    Widget _buildSummaryRow(TransactionState state) {
      final formatter = NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: 0,
      );
      return Row(

        children: [
          _buildSummaryCard(
            label: 'Income',
            amount: formatter.format(state.totalIncome),
            color: const Color(0xFF4CAF50),
          ),
          SizedBox(width: 8),
          _buildSummaryCard(
            label: 'Expense',
            amount: formatter.format(state.totalExpense),
            color: const Color(0xFFef5350),
          ),
          SizedBox(width: 8),
          _buildSummaryCard(
            label: 'Balance',
            amount: formatter.format(state.balance),
            color: const Color(0xFFD4AF37),
          ),
        ],
      );
    }

    Widget _buildSummaryCard({
      required String label,
      required String amount,
      required Color color,
    }) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 9,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildTransactionList(BuildContext context, TransactionState state) {
      if (state.status == TransactionStatus.loading) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
        );
      }
      if (state.filteredTransactions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_rounded, size: 40),
              const SizedBox(height: 16),
              const Text(
                'No Transactions found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Try a different filter',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }
      final grouped = state.groupedTransactions;
      final monthKeys = grouped.keys.toList();
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: monthKeys.length,
        itemBuilder: (context, index) {
          final monthKey = monthKeys[index];
          final transactions = grouped[monthKey]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _formatMonthKey(monthKey),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 11,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ...transactions.map((txn) => _buildTransactionItem(context, txn)),

              const SizedBox(height: 16),
            ],
          );
        },
      );
    }

    Widget _buildTransactionItem(BuildContext context, TransactionModel txn) {
      final formatter = NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: 0,
      );
      final categoryStyle = {
        'Shopping': {
          'icon': Icons.shopping_cart_rounded,
          'color': const Color(0xFF9C27B0),
        },
        'Food': {
          'icon': Icons.restaurant_rounded,
          'color': const Color(0xFFFF9800),
        },
        'Transport': {
          'icon': Icons.directions_car_rounded,
          'color': const Color(0xFF2196F3),
        },
        'Bills': {'icon': Icons.bolt_rounded, 'color': const Color(0xFFFFC107)},
        'Health': {
          'icon': Icons.medical_services_rounded,
          'color': const Color(0xFFE91E63),
        },
        'Entertainment': {
          'icon': Icons.movie_rounded,
          'color': const Color(0xFF673AB7),
        },
        'Salary': {
          'icon': Icons.account_balance_wallet_rounded,
          'color': const Color(0xFF4CAF50),
        },
        'Other': {
          'icon': Icons.category_rounded,
          'color': const Color(0xFF607D8B),
        },
      };
      final style = categoryStyle[txn.category] ?? categoryStyle['other']!;
      final catIcon = style['icon'] as IconData;
      final catColor = style['color'] as Color;

      return Dismissible(
        key: Key(txn.id),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),

          child: const Icon(
            Icons.delete_rounded,
            color: Colors.redAccent,
            size: 22,
          ),
        ),
        confirmDismiss: (direction) async {
          return await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: const Color(0xFF1a3a5c),
              title: const Text(
                'Delete Transaction?',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              content: Text(
                'Are you sure you want to delete ${txn.title}?',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          );
        },
        onDismissed: (direction) {
          context.read<TransactionBloc>().add(TransactionDeleted(txn.id));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${txn.title} deleted'),
              backgroundColor: Colors.redAccent,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: catColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Icon(catIcon, color: catColor, size: 19)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      txn.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${DateFormat('MMM d').format(txn.date)} · ${txn.category}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${txn.isIncome ? '+' : '-'}${formatter.format(txn.amount)}',
                style: TextStyle(
                  color: txn.isIncome
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFef5350),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildBottomNav(BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0d1f35),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFFD4AF37),
          unselectedItemColor: Colors.white.withOpacity(0.3),
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/dashboard');
                break;
              case 1:
                context.go('/transaction');
                break;
              case 2:
                context.go('/budget');
                break;
              case 3:
                context.go('/profile');
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_rounded),
              label: 'Transactions',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_rounded),
              label: 'Budget',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      );
    }

    String _formatMonthKey(String key) {
      final parts = key.split('-');
      final date = DateTime(int.parse(parts[0]), int.parse(parts[1]));
      return DateFormat('MMMM yyyy').format(date).toUpperCase();
    }
  }
