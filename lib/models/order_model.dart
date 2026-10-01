class OrderHistory {
  final int? id;
  final double totalPrice;
  final String date;

  OrderHistory({
    this.id,
    required this.totalPrice,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalPrice': totalPrice,
      'date': date,
    };
  }

  factory OrderHistory.fromMap(Map<String, dynamic> map) {
    return OrderHistory(
      id: map['id'],
      totalPrice: (map['totalPrice'] is num)
          ? (map['totalPrice'] as num).toDouble()
          : 0.0,
      date: map['date']?.toString() ?? '',
    );
  }
}