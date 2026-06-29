class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final bool isIncome;
  final DateTime date;
  final String category;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.date,
    required this.category,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return TransactionModel(
      id: id,
      title: map['title'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      isIncome: map['isIncome'] ?? false,
      date: DateTime.parse(map['date']),
      category: map['category'] ?? 'Other',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'isIncome': isIncome,
      'date': date.toIso8601String(),
      'category': category,
    };
  }
}
