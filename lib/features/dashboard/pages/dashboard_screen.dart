import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:fintrack/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc()..add(DashboardStarted()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return SafeArea(
            child: RefreshIndicator(
              color: const Color(0xFFD4AF37),
              backgroundColor: const Color(0xFF0A1628),

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildTopBar(context, state),
                    const SizedBox(height: 20),
                    _buildBalanceCard(state),
                    const SizedBox(height: 20),
                    _buildChartSection(state),
                    const SizedBox(height: 20),
                    _buildRecentTransactions(context, state),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              onRefresh: () async {
                context.read<DashboardBloc>().add(DashboardRefreshed());
                //wait for state to update
                await Future.delayed(const Duration(seconds: 1));
              },
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildTopBar(BuildContext context, DashboardState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.45),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${state.userName.isEmpty ? 'User' : state.userName}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => context.go('/profile'),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                state.userName.isEmpty ? 'U' : state.userName[0].toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFF0A1628),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(DashboardState state) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1a3a5c), Color(0xFF0d2137)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4AF38).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL BALANCE',
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontSize: 11,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          state.status == DashboardStatus.loading
              ? _buildShimmer(width: 160, height: 36)
              : Text(
                  formatter.format(state.totalBalance),
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMiniStat(
                label: 'INCOME',
                amount: formatter.format(state.totalIncome),
                color: const Color(0xFF4CAF50),
                icon: Icons.arrow_downward_rounded,
                isLoading: state.status == DashboardStatus.loading,
              ),
              const SizedBox(width: 16),
              _buildMiniStat(
                label: 'EXPENSES',
                amount: formatter.format(state.totalExpense),
                color: const Color(0xFFef5350),
                icon: Icons.arrow_upward_rounded,
                isLoading: state.status == DashboardStatus.loading,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat({
    required String label,
    required String amount,
    required Color color,
    required IconData icon,
    required bool isLoading,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 9,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 2),
              isLoading
                  ? _buildShimmer(width: 60, height: 14)
                  : Text(
                      amount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(DashboardState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Monthly Spending',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'See all',
              style: TextStyle(color: const Color(0xFFD4AF37), fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar('Jan', 0.4),
              _buildBar('Feb', 0.6),
              _buildBar('Mar', 0.3),
              _buildBar('Apr', 0.7),
              _buildBar('May', 0.5),
              _buildBar('Jun', 0.9, isActive: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBar(String month, double heightFactor, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 28,
          height: 70 * heightFactor,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFFD4AF37)
                : const Color(0xFFD4AF37).withOpacity(0.25),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          month,
          style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(BuildContext context, DashboardState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: () => context.go('/transactions'),
              child: const Text(
                'See all',
                style: TextStyle(color: Color(0xFFD4AF37), fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (state.status == DashboardStatus.loading)
          ...List.generate(3, (_) => _buildTransactionShimmer()),

        if (state.status == DashboardStatus.success &&
            state.recentTransactions.isEmpty)
          _buildEmptyState(),

        if (state.status == DashboardStatus.success &&
            state.recentTransactions.isNotEmpty)
          ...state.recentTransactions.map((txn) => _buildTransactionItem(txn)),
      ],
    );
  }

  Widget _buildTransactionItem(TransactionModel txn) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    final categoryIcons = {
      'Food': '🍔',
      'Shopping': '🛒',
      'Transport': '🚗',
      'Bills': '⚡',
      'Salary': '💰',
      'Health': '💊',
      'Entertainment': '🎬',
      'Other': '📦',
    };
    return Container(
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
              color: txn.isIncome
                  ? const Color(0xFF4CAF50).withOpacity(0.1)
                  : const Color(0xFFef5350).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                categoryIcons[txn.category] ?? '📦',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  DateFormat('MMM d, yyyy').format(txn.date),
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
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Text(
            'No Transactions yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Add your first transaction\nto get started',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _buildTransactionShimmer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildShimmer(width: 40, height: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmer(width: 120, height: 1),
                const SizedBox(height: 6),
                _buildShimmer(width: 80, height: 10),
              ],
            ),
          ),
          _buildShimmer(width: 60, height: 14),
        ],
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
              context.go('/transactions');
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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening.';
  }
}
