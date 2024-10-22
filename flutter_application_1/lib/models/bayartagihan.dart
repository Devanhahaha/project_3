class Bayartagihan {
  final int id;
  final int transaksiId;
  final String nama;
  final String noTagihan;
  final String tipeTagihan;
  final int nominal;
  final DateTime createdAt;
  final DateTime updatedAt;

  Bayartagihan({
    required this.id,
    required this.transaksiId,
    required this.nama,
    required this.noTagihan,
    required this.tipeTagihan,
    required this.nominal,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a Bill object from JSON
  factory Bayartagihan.fromJson(Map<String, dynamic> json) {
    return Bayartagihan(
      id: json['id'],
      transaksiId: json['transaksi_id'],
      nama: json['nama'],
      noTagihan: json['no_tagihan'],
      tipeTagihan: json['tipe_tagihan'],
      nominal: json['nominal'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert a Bill object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaksi_id': transaksiId,
      'nama': nama,
      'no_tagihan': noTagihan,
      'tipe_tagihan': tipeTagihan,
      'nominal': nominal,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Factory method to create a list of Bill objects from a list of JSON objects
  static List<Bayartagihan> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Bayartagihan.fromJson(json)).toList();
  }
}
