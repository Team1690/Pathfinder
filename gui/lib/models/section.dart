import "package:pathfinder/models/segment.dart";

class Section {
  Section({
    required this.segments,
    required this.index,
  });

  factory Section.initial({final List<Segment>? segments}) => Section(
        segments: segments ?? <Segment>[],
        index: 0,
      );

  Section.fromJson(final dynamic json)
      : segments = (json["pathPoints"] as List<dynamic>)
            .map(Segment.fromJson)
            .toList(),
        index = json["index"] as int;

  final List<Segment> segments;
  final int index;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "segments":
            segments.map((final Segment segment) => segment.toJson()).toList(),
        "index": index,
      };

  Section copyWith({
    final List<Segment>? segments,
    final int? index,
  }) =>
      Section(
        segments: segments ?? this.segments,
        index: index ?? this.index,
      );
}
