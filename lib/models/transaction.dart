import '../utils/extensions.dart';
import 'category.dart';

class Transaction {
  final Category category;
  final String remarks;
  final DateTime date;
  final num amount;
  final TransactionType transactionType;

  Transaction(
    this.category,
    this.remarks,
    this.date,
    this.amount,
    this.transactionType,
  );

  String get subtitle => '${category.title}\n${date.readableFormat}';
  String get amountFormatted => amount.currencyFormat;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'category': category.toMap()});
    result.addAll({'remarks': remarks});
    result.addAll({'date': date.millisecondsSinceEpoch});
    result.addAll({'amount': amount});
    result.addAll({'transactionType': transactionType.name});

    return result;
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      Category.fromMap(map['category'] as Map<String, dynamic>),
      map['remarks'] as String? ?? '',
      DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      map['amount'] as int? ?? 0,
      TxEx.fromName(map['transactionType'] as String),
    );
  }
}

enum TransactionType { income, expense }

extension TxEx on TransactionType {
  static TransactionType fromName(String n) {
    if (n == 'expense') {
      return TransactionType.expense;
    }
    return TransactionType.income;
  }
}
