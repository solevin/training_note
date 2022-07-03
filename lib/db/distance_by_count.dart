class DistanceByCount {
  DistanceByCount({
    this.id,
    required this.club,
    required this.kind,
    required this.distance,
  });

  DistanceByCount.fromMap(Map<String, dynamic> paramMap)
      : id = paramMap['id'] as int,
        club = paramMap['club'] as String,
        kind = paramMap['kind'] as int,
        distance = paramMap['distance'] as int;

  final int? id;
  final String club;
  final int kind;
  final int distance;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'club': club,
        'kind': kind,
        'distance': distance,
      };

  Map<String, dynamic> toMapExceptId() {
    final cloneMap = <String, dynamic>{...toMap()}..remove('id');
    return cloneMap;
  }
}
