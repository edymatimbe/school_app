class LessonState {
  final String? title;
  final String? courseId;
  final String? descricao;

  LessonState({this.title, this.courseId, this.descricao});

  LessonState copyWith({String? title, String? courseId, String? descricao}) {
    return LessonState(
      title: title ?? this.title,
      courseId: courseId ?? this.courseId,
      descricao: descricao ?? this.descricao,
    );
  }

  factory LessonState.fromMap(Map<String, dynamic> map) {
    return LessonState(
      title: map['title'],
      courseId: map['courseId'],
      descricao: map['descricao'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'courseId': courseId, 'descricao': descricao};
  }
}
