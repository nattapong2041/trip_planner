import 'package:freezed_annotation/freezed_annotation.dart';
import 'brainstorm_idea.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

@freezed
abstract class Activity with _$Activity {
  const factory Activity({
    required String id,
    required String tripId,
    required String place,
    required String activityType,
    String? price,
    String? notes,
    String? assignedDay, // null if in activity pool
    int? dayOrder,
    required String createdBy,
    required DateTime createdAt,
    @Default([]) List<BrainstormIdea> brainstormIdeas,
  }) = _Activity;
  
  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
}