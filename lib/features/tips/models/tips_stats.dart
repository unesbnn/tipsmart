class TipsStats {
  final int correct, incorrect, pending, canceled, total;
  final String? successRate;

  TipsStats({
    required this.correct,
    required this.incorrect,
    required this.pending,
    required this.canceled,
    required this.total,
    required this.successRate,
  });

  factory TipsStats.fromJson(Map<String, dynamic> json) => TipsStats(
        correct: json['correct'],
        incorrect: json['incorrect'],
        pending: json['pending'],
        canceled: json['canceled'],
        total: json['total'],
        successRate: json['successRate'],
      );
}
