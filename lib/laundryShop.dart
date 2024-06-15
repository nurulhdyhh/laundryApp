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
      name: json['name'],
      rating: json['rating'],
      address: json['address'],
      type: json['type'],
      imageUrl: json['image_url'],
      description: json['description'],
      price: json['price'],
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
