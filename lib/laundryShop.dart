class LaundryShop {
  final String name;
  final double rating;
  final String address;
  final String type;
  final String imageUrl;
  final String description;
  final String price;

  LaundryShop({
    required this.name,
    required this.rating,
    required this.address,
    required this.type,
    required this.imageUrl,
    required this.description,
    required this.price,
  });

  factory LaundryShop.fromJson(Map<String, dynamic> json) {
    return LaundryShop(
      name: json['name'] ?? 'Unknown', // Default value for name
      rating: (json['rating'] as num?)?.toDouble() ??
          0.0, // Convert to double and default to 0.0
      address:
          json['address'] ?? 'No address provided', // Default value for address
      type: json['type'] ?? 'Regular', // Default value for type
      imageUrl: json['image_url'] ?? '', // Default value for imageUrl
      description: json['description'] ??
          'No description provided', // Default value for description
      price: json['price'] ?? '0', // Default value for price
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'rating': rating,
        'address': address,
        'type': type,
        'image_url': imageUrl,
        'description': description,
        'price': price,
      };
}
