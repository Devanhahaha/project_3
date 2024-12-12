import 'package:flutter_application_1/models/product.dart';

class ProductCust {
  final int id;
  final int productId;
  final int transaksiId;
  final String noHp;
  final String alamat;
  final String catatan;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String provinsi;
  final String kabupaten;
  final String ongkir;
  final String kurir;
  final String? ongkiru; // Pertimbangkan jika ini perlu
  final int quantity;
  late final int subTotal; // Menggunakan late karena akan dihitung di konstruktor
  final Product? product;

  ProductCust({
    required this.id,
    required this.productId,
    required this.transaksiId,
    required this.noHp,
    required this.alamat,
    required this.catatan,
    required this.createdAt,
    required this.updatedAt,
    required this.provinsi,
    required this.kabupaten,
    required this.ongkir,
    required this.kurir,
    this.ongkiru,
    required this.quantity,
    required Product? product, // Menggunakan Product? untuk mendapatkan produk
  }) : product = product {
    // Menghitung subTotal saat konstruksi objek
    subTotal = product?.nominal ?? 0 * quantity;
  }

  factory ProductCust.fromJson(Map<String, dynamic> json) {
    return ProductCust(
      id: json['id'],
      productId: json['product_id'],
      transaksiId: json['transaksi_id'],
      noHp: json['no_hp'],
      alamat: json['alamat'],
      catatan: json['catatan'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      provinsi: json['provinsi'],
      kabupaten: json['kabupaten'],
      ongkir: json['ongkir'],
      kurir: json['kurir'],
      ongkiru: json['ongkiru'],
      quantity: json['quantity'],
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
    );
  }

  // Method untuk menghitung subTotal berdasarkan quantity
  void calculateSubTotal() {
    subTotal = (product?.nominal ?? 0) * quantity;
  }

  static List<ProductCust> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ProductCust.fromJson(json)).toList();
  }
}
