class TransactionData {
  final String bulan;
  final int total;

  TransactionData(this.bulan, this.total);

  // fromJson method
  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      json['bulan'] as String,
      json['total_transaksi'] as int,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'bulan': bulan,
      'total_transaksi': total,
    };
  }
}
