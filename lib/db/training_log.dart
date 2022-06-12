class TrainingLog {
  TrainingLog({
    this.id,
    required this.date,
    required this.ballQuantity,
    required this.memo,
  });

  TrainingLog.fromMap(Map<String, dynamic> paramMap)
      : id = paramMap['id'] as int,
        date = paramMap['date'] as String,
        ballQuantity = paramMap['ballQuantity'] as int,
        memo = paramMap['memo'] as String;

  final int? id;
  final String date;
  final int ballQuantity;
  final String memo;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'date': date,
        'ballQuantity': ballQuantity,
        'memo': memo,
      };

  Map<String, dynamic> toMapExceptId() {
    final cloneMap = <String, dynamic>{...toMap()}..remove('id');
    return cloneMap;
  }
}
