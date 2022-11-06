class Note {
  // будет автоматом  получаться из базы
  late int id;

  String title;
  String body;
  int date;
  bool isPoem;
  //final bool isMarkdown;

  Note({
    this.title = 'empty',
    this.body = '',
    this.date = 0,
    this.isPoem = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': title,
      'body': body,
      'date': date,
      'isPoem': isPoem,
    };
  }

  static Note fromMap(Map<dynamic, dynamic> map) {
    return Note(
      title: map['name'],
      body: map['body'],
      date: map['date'],
      isPoem: map['isPoem'],
    );
  }
}
