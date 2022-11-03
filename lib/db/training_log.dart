class TrainingLog {
  TrainingLog({
    this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.ballQuantity,
    required this.isgame,
    required this.score,
    required this.memo,
  });

  TrainingLog.fromMap(Map<String, dynamic> paramMap)
      : id = paramMap['id'] as int,
        year = paramMap['year'] as int,
        month= paramMap['month'] as int,
        day = paramMap['day'] as int,
        ballQuantity = paramMap['ballQuantity'] as int,
        isgame = paramMap['isgame'] as int,
        score = paramMap['score'] as int,
        memo = paramMap['memo'] as String;

  final int? id;
  final int year;
  final int month;
  final int day;
  final int ballQuantity;
  final int isgame;
  final int score;
  final String memo;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'year': year,
        'month': month,
        'day': day,
        'ballQuantity': ballQuantity,
        'isgame': isgame,
        'score': score,
        'memo': memo,
      };

  Map<String, dynamic> toMapExceptId() {
    final cloneMap = <String, dynamic>{...toMap()}..remove('id');
    return cloneMap;
  }
}
