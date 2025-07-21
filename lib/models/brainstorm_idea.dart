import 'package:freezed_annotation/freezed_annotation.dart';

part 'brainstorm_idea.freezed.dart';
part 'brainstorm_idea.g.dart';

@freezed
abstract class BrainstormIdea with _$BrainstormIdea {
  const factory BrainstormIdea({
    required String id,
    required String description,
    required String createdBy,
    required DateTime createdAt,
  }) = _BrainstormIdea;
  
  factory BrainstormIdea.fromJson(Map<String, dynamic> json) => _$BrainstormIdeaFromJson(json);
}