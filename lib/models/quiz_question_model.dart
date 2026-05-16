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
      id: _toInt(json['id'] ?? json['question_id']),
      currentNumber: _toInt(
        json['current_number'] ??
            json['currentNumber'] ??
            json['question_num'] ??
            json['number'] ??
            0,
      ),
      text: json['text']?.toString() ?? json['question']?.toString() ?? '',
      optionA: json['option_a']?.toString() ??
          json['optionA']?.toString() ??
          json['a']?.toString() ??
          '',
      optionB: json['option_b']?.toString() ??
          json['optionB']?.toString() ??
          json['b']?.toString() ??
          '',
      optionC: json['option_c']?.toString() ??
          json['optionC']?.toString() ??
          json['c']?.toString() ??
          '',
      optionD: json['option_d']?.toString() ??
          json['optionD']?.toString() ??
          json['d']?.toString() ??
          '',
    );
  }

  List<String> get options => [
        optionA,
        optionB,
        optionC,
        optionD,
      ];

  List<String> get optionKeys => ['a', 'b', 'c', 'd'];

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
