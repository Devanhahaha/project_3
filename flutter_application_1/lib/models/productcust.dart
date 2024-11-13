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
  final String? ongkiru;
  final int quantity;
  final int subTotal;
  final Product? product;
  // final String gambar;

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
    required this.subTotal,
    this.product,
    // required this.gambar,
  });

  // Method fromJson untuk parsing JSON menjadi objek Transaction
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
      subTotal: json['sub_total'],
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
      // gambar: json['gambar'],
    );
  }

  // Method fromJsonList untuk parsing list JSON menjadi list objek Transaction
  static List<ProductCust> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ProductCust.fromJson(json)).toList();
  }
}
