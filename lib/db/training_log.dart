class TrainingLog {
  TrainingLog({
    this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.ballQuantity,
    required this.isGame,
    required this.score,
    required this.memo,
    required this.time,
  });

  TrainingLog.fromMap(Map<String, dynamic> paramMap)
      : id = paramMap['id'] as int,
        year = paramMap['year'] as int,
        month= paramMap['month'] as int,
        day = paramMap['day'] as int,
        ballQuantity = paramMap['ballQuantity'] as int,
        isGame = paramMap['isGame'] as int,
        score = paramMap['score'] as int,
        memo = paramMap['memo'] as String,
        time = paramMap['time'] as int;

  final int? id;
  final int year;
  final int month;
  final int day;
  final int ballQuantity;
  final int isGame;
  final int score;
  final String memo;
  final int time;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'year': year,
        'month': month,
        'day': day,
        'ballQuantity': ballQuantity,
        'isGame': isGame,
        'score': score,
        'memo': memo,
        'time': time,
      };

  Map<String, dynamic> toMapExceptId() {
    final cloneMap = <String, dynamic>{...toMap()}..remove('id');
    return cloneMap;
  }
}
