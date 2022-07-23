class Advice {
  Advice({
    this.id,
    required this.contents,
    required this.date,
    required this.isAchieved,
    required this.source,
  });

  Advice.fromMap(Map<String, dynamic> paramMap)
      : id = paramMap['id'] as int,
        contents = paramMap['contents'] as String,
        date = paramMap['date'] as String,
        isAchieved = paramMap['isAchieved'] as int,
        source = paramMap['source'] as String;

  final int? id;
  final String contents;
  final String date;
  final int isAchieved;
  final String source;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'contents': contents,
        'date': date,
        'isAchieved': isAchieved,
        'source': source,
      };

  Map<String, dynamic> toMapExceptId() {
    final cloneMap = <String, dynamic>{...toMap()}..remove('id');
    return cloneMap;
  }
}
