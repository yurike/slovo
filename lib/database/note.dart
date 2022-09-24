class Note {
  // будет автоматом  получаться из базы
  late int id;

  final String name;
  String body;
  final bool isPoem;
  //final bool isMarkdown;

  Note({
    required this.name,
    this.body = '',
    required this.isPoem,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'body': body,
      'isPoem': isPoem,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      name: map['name'],
      body: map['body'],
      isPoem: map['isPoem'],
    );
  }
}
