class Segment {
  Segment({
    required this.pointIndexes,
    required this.maxVelocity,
    required this.isHidden,
  });

  factory Segment.initial() => Segment.fromPointIndexes(
        pointIndexes: <int>[],
      );

  factory Segment.fromPointIndexes({required final List<int> pointIndexes}) =>
      Segment(
        pointIndexes: pointIndexes,
        maxVelocity: 3,
        isHidden: false,
      );

  Segment.fromJson(final dynamic json)
      : pointIndexes = (json["pointIndexes"] as List<dynamic>).cast<int>(),
        maxVelocity = json["maxVelocity"] as double,
        isHidden = json["isHidden"] as bool;

  final List<int> pointIndexes;
  final double maxVelocity;
  final bool isHidden;

  //TODO: implement tank

  Segment copyWith({
    final List<int>? pointIndexes,
    final double? maxVelocity,
    final bool? isHidden,
  }) =>
      Segment(
        pointIndexes: pointIndexes ?? this.pointIndexes,
        maxVelocity: maxVelocity ?? this.maxVelocity,
        isHidden: isHidden ?? this.isHidden,
      );

  dynamic toJson() => <String, dynamic>{
        "pointIndexes": pointIndexes,
        "maxVelocity": maxVelocity,
        "isHidden": isHidden,
      };

  @override
  String toString() => pointIndexes.toString();
}
