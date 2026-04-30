import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/certificate_viewmodel.dart';

class CertificatePage extends StatefulWidget {
  const CertificatePage({super.key});

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CertificateViewModel>().fetchCertificates();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CertificateViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sertifikat'),
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
              ? Center(child: Text(vm.errorMessage!))
              : vm.certificates.isEmpty
                  ? const Center(child: Text('Belum ada sertifikat'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: vm.certificates.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final cert = vm.certificates[index];

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                            border: Border.all(color: const Color(0xFFFF3B30)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cert.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                cert.category,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final File? file =
                                        await vm.downloadCertificate(
                                      certificateId: cert.certificateId,
                                      fileName: cert.title,
                                    );

                                    if (file != null && context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Sertifikat berhasil diunduh: ${file.path}',
                                          ),
                                        ),
                                      );

                                      await OpenFilex.open(file.path);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF2D2D),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                  child: const Text('Download Sertifikat'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}
