import 'package:flutter/material.dart';

Future<void> showCertificatePaymentDialog(BuildContext context) async {
  await showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.45),
    builder: (dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 36),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Unduh Sertifikat',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 230,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFD7AD45),
                          width: 5,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.workspace_premium_outlined,
                          color: Color(0xFFD7AD45),
                          size: 58,
                        ),
                      ),
                    ),
                    Container(
                      width: 132,
                      height: 132,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.82),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF8A8A8A),
                        size: 34,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Untuk membuka kunci sertifikat secara\npermanen, silahkan lakukan pembayaran:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'RP 45.000',
                style: TextStyle(
                  color: Color(0xFFED1E28),
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Sertifikat Digital Resmi',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);

                    Future.microtask(() {
                      if (context.mounted) {
                        showPaymentDevelopmentDialog(context);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFED1E28),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    'Bayar & Unduh Sekarang',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFED1E28),
                    side: const BorderSide(
                      color: Color(0xFFED1E28),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    'Mungkin Nanti',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> showPaymentDevelopmentDialog(BuildContext context) async {
  await showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.45),
    builder: (dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 36),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 34, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 108,
                height: 108,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF0D17),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.computer,
                  color: Colors.white,
                  size: 58,
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'Fitur Pembayaran Sedang\nDalam Pengembangan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 18,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 110,
                height: 38,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFED1E28),
                    side: const BorderSide(
                      color: Color(0xFFED1E28),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Kembali',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
