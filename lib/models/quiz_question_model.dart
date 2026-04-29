class QuizQuestionModel {
  final int id;
  final int currentNumber;
  final String text;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;

  QuizQuestionModel({
    required this.id,
    required this.currentNumber,
    required this.text,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'] ?? 0,
      currentNumber: json['current_number'] ?? 0,
      text: json['text'] ?? '',
      optionA: json['option_a'] ?? '',
      optionB: json['option_b'] ?? '',
      optionC: json['option_c'] ?? '',
      optionD: json['option_d'] ?? '',
    );
  }

  List<String> get options => [
        optionA,
        optionB,
        optionC,
        optionD,
      ];

  List<String> get optionKeys => ['a', 'b', 'c', 'd'];
}
