import 'package:flutter/material.dart';

class CreatePostDialog extends StatefulWidget {
  final Future<bool> Function({
    required String title,
    required String content,
    required String category,
    required List<String> tags,
  }) onSubmit;

  const CreatePostDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final hashtagController = TextEditingController();

  String selectedCategory = 'Umum';
  bool isLoading = false;

  final categories = ['Umum', 'Tips & trik', 'Bantuan'];

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    hashtagController.dispose();
    super.dispose();
  }

  List<String> _parseTags(String value) {
    return value
        .split(',')
        .map((tag) => tag.replaceAll('#', '').trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }

  Future<void> _submit() async {
    setState(() {
      isLoading = true;
    });

    final success = await widget.onSubmit(
      title: titleController.text,
      content: contentController.text,
      category: selectedCategory,
      tags: _parseTags(hashtagController.text),
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 18, 30, 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          'Posting forum',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Isi detail postingan mu',
                          style: TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.cancel_outlined,
                        color: Color(0xFFF91D2F),
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _Label('Judul postingan'),
              const SizedBox(height: 8),
              _InputField(
                controller: titleController,
                hintText: 'Contoh : bagaimana cara mendapatkan setifikat',
              ),
              const SizedBox(height: 17),
              _Label('Kategori'),
              const SizedBox(height: 8),
              Row(
                children: categories.map((category) {
                  final isSelected = selectedCategory == category;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        child: Container(
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFF91D2F)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFF91D2F)
                                  : const Color(0xFFC8C8C8),
                            ),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 17),
              _Label('Isi postingan'),
              const SizedBox(height: 8),
              _InputField(
                controller: contentController,
                hintText: 'Catatan Tambahan',
                height: 91,
                maxLines: 5,
              ),
              const SizedBox(height: 17),
              _Label('Hashtage'),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 180,
                  child: _InputField(
                    controller: hashtagController,
                    hintText: 'Contoh : # Sertifikat',
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 121,
                  height: 43,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF91D2F),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          const Color(0xFFF91D2F).withOpacity(0.5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
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
                            'Post forum',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                  ),
                ),
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

  const _InputField({
    required this.controller,
    required this.hintText,
    this.height = 30,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
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
