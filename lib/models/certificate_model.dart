class CertificateModel {
  final String title;
  final String category;
  final String certificateId;

  CertificateModel({
    required this.title,
    required this.category,
    required this.certificateId,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      certificateId: json['certificate_id'] ?? '',
    );
  }
}
