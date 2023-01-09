class Media {
  Media({
    this.id,
    required this.type,
    required this.year,
    required this.month,
    required this.day,
    required this.path,
  });

  Media.fromMap(Map<String, dynamic> paramMap)
      : id = paramMap['id'] as int,
        type = paramMap['type'] as String,
        year = paramMap['year'] as int,
        month = paramMap['month'] as int,
        day = paramMap['day'] as int,
        path = paramMap['path'] as String;

  final int? id;
  final String type;
  final int year;
  final int month;
  final int day;
  final String path;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'type': type,
        'year': year,
        'month': month,
        'day': day,
        'path': path,
      };

  Map<String, dynamic> toMapExceptId() {
    final cloneMap = <String, dynamic>{...toMap()}..remove('id');
    return cloneMap;
  }
}
