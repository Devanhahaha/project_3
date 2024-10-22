class Pulsa {
  final int id;
  final int transaksiId;
  final String nama;
  final String noTelp;
  final String tipeKartu;
  final int nominal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? harga;

  Pulsa({
    required this.id,
    required this.transaksiId,
    required this.nama,
    required this.noTelp,
    required this.tipeKartu,
    required this.nominal,
    required this.createdAt,
    required this.updatedAt,
    this.harga,
  });

  // Factory method to create a Pulsa object from JSON
  factory Pulsa.fromJson(Map<String, dynamic> json) {
    return Pulsa(
      id: json['id'],
      transaksiId: json['transaksi_id'],
      nama: json['nama'],
      noTelp: json['no_telp'],
      tipeKartu: json['tipe_kartu'],
      nominal: json['nominal'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      harga: json['harga']?.toDouble(),
    );
  }

  // Method to convert a Pulsa object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaksi_id': transaksiId,
      'nama': nama,
      'no_telp': noTelp,
      'tipe_kartu': tipeKartu,
      'nominal': nominal,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'harga': harga,
    };
  }

  // Factory method to create a list of Pulsa objects from a list of JSON objects
  static List<Pulsa> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Pulsa.fromJson(json)).toList();
  }
}
