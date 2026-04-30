import 'dart:io';
import 'package:flutter/material.dart';
import '../models/certificate_model.dart';
import '../services/certificate_service.dart';

class CertificateViewModel extends ChangeNotifier {
  final CertificateService _service = CertificateService();

  bool isLoading = false;
  String? errorMessage;
  List<CertificateModel> certificates = [];

  Future<void> fetchCertificates() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      certificates = await _service.getCertificates();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> generateCertificate(String quizId) async {
    try {
      final certificateId = await _service.generateCertificate(quizId);
      return certificateId;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  Future<File?> downloadCertificate({
    required String certificateId,
    required String fileName,
  }) async {
    try {
      final file = await _service.downloadCertificate(certificateId, fileName);
      return file;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return null;
    }
  }
}
