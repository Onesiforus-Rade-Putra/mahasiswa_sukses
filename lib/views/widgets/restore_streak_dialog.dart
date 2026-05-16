import 'package:flutter/material.dart';

import 'certificate_payment.dart';

Future<void> showRestoreStreakDialog(BuildContext context) async {
  await showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.55),
    builder: (dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 34),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 22, 14, 22),
                color: const Color(0xFFFF000D),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.local_fire_department,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lanjutkan Streak?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Pilih opsi untuk menghidupkan\nkembali streak harian kamu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(dialogContext);
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
                child: Column(
                  children: [
                    _RestoreStreakOptionCard(
                      price: 'IDR 5,000',
                      pointText: 'Gunakan 45 poin',
                      subtitle: 'Cepat dan langsung!',
                      onBuy: () {
                        Navigator.pop(dialogContext);

                        Future.microtask(() {
                          if (context.mounted) {
                            showPaymentDevelopmentDialog(context);
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _RestoreStreakOptionCard(
                      price: 'IDR 9,000',
                      pointText: 'Gunakan 45 poin',
                      subtitle: 'Panjangin streak!',
                      onBuy: () {
                        Navigator.pop(dialogContext);

                        Future.microtask(() {
                          if (context.mounted) {
                            showPaymentDevelopmentDialog(context);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _RestoreStreakOptionCard extends StatelessWidget {
  final String price;
  final String pointText;
  final String subtitle;
  final VoidCallback onBuy;

  const _RestoreStreakOptionCard({
    required this.price,
    required this.pointText,
    required this.subtitle,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFFF0D17),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bolt,
              color: Colors.white,
              size: 31,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lanjutkan Streak',
                  style: TextStyle(
                    color: Color(0xFF222222),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  price,
                  style: const TextStyle(
                    color: Color(0xFF222222),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  pointText,
                  style: const TextStyle(
                    color: Color(0xFFED1E28),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.bolt,
                      color: Color(0xFFFFC107),
                      size: 17,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFFED1E28),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: SizedBox(
                    width: 100,
                    height: 34,
                    child: OutlinedButton(
                      onPressed: onBuy,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFED1E28),
                        side: const BorderSide(
                          color: Color(0xFFED1E28),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Beli',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
