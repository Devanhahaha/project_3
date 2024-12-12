import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product.dart';
import '../models/cartitem.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.length;

  void addItem(Product product, int productId, String namaProduct, String gambar, int nominal) {
    if (_items.containsKey(productId.toString())) {
      _items.update(
        productId.toString(),
        (existingItem) => CartItem(
          product: existingItem.product,
          productId: existingItem.productId,
          productName: existingItem.productName,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
          imageUrl: existingItem.imageUrl,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId.toString(),
        () => CartItem(
          product: product,
          productId: productId,
          productName: namaProduct,
          quantity: 1,
          price: nominal,
          imageUrl: gambar,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  double get totalAmount {
    return _items.values
        .fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }
}
