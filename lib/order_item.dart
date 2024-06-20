class OrderItem {
  final String laundryOption;
  final int kg;
  final double price;
  final String storeName;
  final String storeImagePath;
  final String timestamp;
  final double totalAmount;
  final double deliveryCharge;
  final double totalPayable;
  final String status;

  OrderItem({
    required this.laundryOption,
    required this.kg,
    required this.price,
    required this.storeName,
    required this.storeImagePath,
    required this.timestamp,
    required this.totalAmount,
    required this.deliveryCharge,
    required this.totalPayable,
    required this.status,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      laundryOption: map['laundryOption'],
      kg: map['kg'],
      price: map['price'],
      storeName: map['storeName'],
      storeImagePath: map['storeImagePath'],
      timestamp: map['timestamp'],
      totalAmount: map['totalAmount'],
      deliveryCharge: map['deliveryCharge'],
      totalPayable: map['totalPayable'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'laundryOption': laundryOption,
      'kg': kg,
      'price': price,
      'storeName': storeName,
      'storeImagePath': storeImagePath,
      'timestamp': timestamp,
      'totalAmount': totalAmount,
      'deliveryCharge': deliveryCharge,
      'totalPayable': totalPayable,
      'status': status,
    };
  }
}

List<OrderItem> cartItems = [];
