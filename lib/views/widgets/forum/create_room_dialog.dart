import 'package:flutter/material.dart';

class CreateRoomDialog extends StatefulWidget {
  final Future<bool> Function({
    required String title,
    required String description,
    required int maxParticipants,
  }) onSubmit;

  const CreateRoomDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<CreateRoomDialog> createState() => _CreateRoomDialogState();
}

class _CreateRoomDialogState extends State<CreateRoomDialog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final maxParticipantsController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    maxParticipantsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final maxParticipants = int.tryParse(maxParticipantsController.text) ?? 0;

    setState(() {
      isLoading = true;
    });

    final success = await widget.onSubmit(
      title: titleController.text,
      description: descriptionController.text,
      maxParticipants: maxParticipants,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 14),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 25, 30, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Buat ruang Belajar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 45),
              _Label('Judul Ruang belajar'),
              const SizedBox(height: 8),
              _InputField(
                controller: titleController,
                hintText: 'Contoh : Study Group : Algoritma pemograman',
              ),
              const SizedBox(height: 17),
              _Label('Isi postingan'),
              const SizedBox(height: 8),
              _InputField(
                controller: descriptionController,
                hintText:
                    'Jelaskan topik yang akan di bahas di\nruang belajar ini...',
                height: 95,
                maxLines: 4,
              ),
              const SizedBox(height: 17),
              _Label('Maksimal Peserta'),
              const SizedBox(height: 8),
              _InputField(
                controller: maxParticipantsController,
                hintText: 'Contoh : 10 peserta',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'maksimal 20 peserta',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        onPressed:
                            isLoading ? null : () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9D9D9),
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: const Color(0xFFD9D9D9),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 46),
                  Expanded(
                    child: SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF91D2F),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              const Color(0xFFF91D2F).withOpacity(0.5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 17,
                                height: 17,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Buat ruang Belajar',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double height;
  final int maxLines;
  final TextInputType? keyboardType;

  const _InputField({
    required this.controller,
    required this.hintText,
    this.height = 30,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF9D9D9D),
            fontSize: 11,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 9,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFFC8C8C8),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFFF91D2F),
            ),
          ),
        ),
      ),
    );
  }
}
