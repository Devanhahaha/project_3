class Services {
  int id;
  int transaksiId;
  String nama;
  String keluhan;
  String jenisHp;
  String kontak;
  int? nominal;
  DateTime createdAt;
  DateTime updatedAt;
  String alamat;

  Services({
    required this.id,
    required this.transaksiId,
    required this.nama,
    required this.keluhan,
    required this.jenisHp,
    required this.kontak,
    required this.nominal,
    required this.createdAt,
    required this.updatedAt,
    required this.alamat,
  });

  // Method to create an instance from JSON
  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      id: json['id'],
      transaksiId: json['transaksi_id'],
      nama: json['nama'],
      keluhan: json['keluhan'],
      jenisHp: json['jenis_hp'],
      kontak: json['kontak'],
      nominal: json['nominal'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      alamat: json['alamat'],
    );
  }

  // Method to convert a list of JSON to a list of LaporanService objects
  static List<Services> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Services.fromJson(json)).toList();
  }
}
