class TransactionResponse {
  final bool status;
  final String? snapToken;

  TransactionResponse({required this.status, this.snapToken});

  // Factory method untuk membuat instance dari JSON
  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      status: json['status'],
      snapToken: json['snap_token'],
    );
  }

  // Metode untuk mengonversi instance ke JSON (opsional)
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'snap_token': snapToken,
    };
  }
}
