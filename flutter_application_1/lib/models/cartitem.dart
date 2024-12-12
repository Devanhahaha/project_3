import 'package:flutter_application_1/models/product.dart';

class CartItem {
  final Product product;
  final int productId;
  final String productName;
  final String imageUrl;
  final int price;
  int quantity;

  CartItem({
    required this.product,
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });
}
