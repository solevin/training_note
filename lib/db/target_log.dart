class TargetLog {
  TargetLog({
    this.id,
    required this.contents,
    required this.deadLine,
    required this.isAchieved,
  });

  TargetLog.fromMap(Map<String, dynamic> paramMap)
      : id = paramMap['id'] as int,
        contents = paramMap['contents'] as String,
        deadLine = paramMap['deadLine'] as String,
        isAchieved = paramMap['isAchieved'] as int;

  final int? id;
  final String contents;
  final String deadLine;
  final int isAchieved;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'contents': contents,
        'deadLine': deadLine,
        'isAchieved': isAchieved,
      };

  Map<String, dynamic> toMapExceptId() {
    final cloneMap = <String, dynamic>{...toMap()}..remove('id');
    return cloneMap;
  }
}
