class CartItemModel {
  final String productId;
  final String name;
  final double price;
  final String image;
  final int quantity;

  const CartItemModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });

  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      productId: productId,
      name: name,
      price: price,
      image: image,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'price': price,
        'image': image,
        'quantity': quantity,
      };

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      quantity: json['quantity'] as int,
    );
  }
}
