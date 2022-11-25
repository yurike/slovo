import 'dart:convert';

class Note {
  // будет автоматом  получаться из базы
  late int id;

  String title;
  String body;
  int created;
  int modified;
  bool markdown;
  //List? tags;

  Note({
    this.title = '',
    this.body = '',
    this.created = 0,
    this.modified = 0,
    this.markdown = false,
    //this.tags,
  });

  factory Note.fromJson(Map myjson) {
    //debugPrint(myjson.runtimeType);
    return Note(
      title: myjson['title'] as String,
      body: myjson['body'] as String,
      created: myjson['created'] as int,
      modified: myjson['modified'] as int,
      markdown: myjson['markdown'] as bool,
      //tags: json.decode(myjson['tags']).cast<String>().toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'created': created,
      'modified': modified,
      'markdown': markdown,
      //'tags': tags,
    };
  }

  factory Note.fromSimpleNoteJson(Map<String, dynamic> myjson) {
    var content = (myjson['content'] as String);
    var titleDividerIdx = content.indexOf("\n\n");
    return Note(
      title: content.substring(0, titleDividerIdx),
      body: content.substring(titleDividerIdx + 2),
      created:
          DateTime.tryParse(myjson['creationDate'])?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
      modified:
          DateTime.tryParse(myjson['lastModified'])?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
      markdown: myjson['markdown'] as bool,
      //tags: myjson['tags'].cast<String>().toList(), // ?
    );
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'name': title,
  //     'body': body,
  //     'created': created,
  //   };
  // }

  // factory Note.fromMap(Map<dynamic, dynamic> map) {
  //   return Note(
  //     title: map['name'],
  //     body: map['body'],
  //     created: map['created'],
  //   );
  // }
}
