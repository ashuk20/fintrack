import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellScreen extends StatelessWidget {
  final Widget child;
  const ShellScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: child,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith('/dashboard')) currentIndex = 0;
    if (location.startsWith('/transaction')) currentIndex = 1;
    if (location.startsWith('/budget')) currentIndex = 2;
    if (location.startsWith('/profile')) currentIndex = 3;
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
        currentIndex: currentIndex,
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
}
