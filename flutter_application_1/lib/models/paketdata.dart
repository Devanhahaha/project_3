class Paketdata {
  final int id;
  final int transaksiId;
  final String nama;
  final String noTelp;
  final String tipeKartu;
  final String nominal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int harga;

  Paketdata({
    required this.id,
    required this.transaksiId,
    required this.nama,
    required this.noTelp,
    required this.tipeKartu,
    required this.nominal,
    required this.createdAt,
    required this.updatedAt,
    required this.harga,
  });

  // Factory method to create a Paketdata object from JSON
  factory Paketdata.fromJson(Map<String, dynamic> json) {
    return Paketdata(
      id: json['id'],
      transaksiId: json['transaksi_id'],
      nama: json['nama'],
      noTelp: json['no_telp'],
      tipeKartu: json['tipe_kartu'],
      nominal: json['nominal'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      harga: json['harga'],
    );
  }

  // Method to convert a Paketdata object to JSON
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

  // Factory method to create a list of Paketdata objects from a list of JSON objects
  static List<Paketdata> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Paketdata.fromJson(json)).toList();
  }
}
