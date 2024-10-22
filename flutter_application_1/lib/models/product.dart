class Product {
  final int id;
  final String namaProduct;
  final String jenis;
  final String merk;
  final String deskripsi;
  final String gambar;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int nominal;
  final int stok;

  Product({
    required this.id,
    required this.namaProduct,
    required this.jenis,
    required this.merk,
    required this.deskripsi,
    required this.gambar,
    required this.createdAt,
    required this.updatedAt,
    required this.nominal,
    required this.stok,
  });

  // Factory method to create a Product object from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      namaProduct: json['nama_product'],
      jenis: json['jenis'],
      merk: json['merk'],
      deskripsi: json['deskripsi'],
      gambar: json['gambar'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      nominal: json['nominal'],
      stok: json['stok'],
    );
  }

  // Method to convert a Product object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_product': namaProduct,
      'jenis': jenis,
      'merk': merk,
      'deskripsi': deskripsi,
      'gambar': gambar,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'nominal': nominal,
      'stok': stok,
    };
  }

  // Factory method to create a list of Product objects from a list of JSON objects
  static List<Product> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Product.fromJson(json)).toList();
  }
}
