import 'dart:convert';

class ItemModel {
  final String by;
  final int descendants;
  final int id;
  final List<dynamic> kids;
  final int score;
  final int time;
  final String title;
  final String type;
  final String url;
  final bool deleted;
  final String text;
  final bool dead;
  final int parent;

  ItemModel(
      {this.by,
      this.descendants,
      this.id,
      this.kids,
      this.score,
      this.time,
      this.title,
      this.type,
      this.url,
      this.deleted,
      this.text,
      this.dead,
      this.parent});

  ItemModel.fromJson(Map<String, dynamic> json)
      : by = json['by'],
        descendants = json['descendants'] ?? 0,
        id = json['id'],
        kids = json['kids'] ?? [],
        score = json['score'],
        time = json['time'],
        title = json['title'],
        type = json['type'],
        url = json['url'],
        deleted = json['deleted'] ?? false,
        text = json['text'] ?? '',
        dead = json['dead'] ?? false,
        parent = json['parent'];

  ItemModel.fromDb(Map<String, dynamic> dbMap)
      : by = dbMap['by'],
        descendants = dbMap['descendants'],
        id = dbMap['id'],
        kids = jsonDecode(dbMap['kids']),
        score = dbMap['score'],
        time = dbMap['time'],
        title = dbMap['title'],
        type = dbMap['type'],
        url = dbMap['url'],
        deleted = dbMap['deleted'] == 1,
        text = dbMap['text'],
        dead = dbMap['dead'] == 1,
        parent = dbMap['parent'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['by'] = this.by;
    data['descendants'] = this.descendants;
    data['id'] = this.id;
    data['kids'] = this.kids;
    data['score'] = this.score;
    data['time'] = this.time;
    data['title'] = this.title;
    data['type'] = this.type;
    data['url'] = this.url;
    data['deleted'] = this.deleted;
    data['text'] = this.text;
    data['dead'] = this.dead;
    data['parent'] = this.parent;
    return data;
  }

  Map<String, dynamic> toDbMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['by'] = this.by;
    data['descendants'] = this.descendants;
    data['id'] = this.id;
    data['kids'] = jsonEncode(this.kids);
    data['score'] = this.score;
    data['time'] = this.time;
    data['title'] = this.title;
    data['type'] = this.type;
    data['url'] = this.url;
    data['deleted'] = this.deleted ? 1 : 0;
    data['text'] = this.text;
    data['dead'] = this.dead ? 1 : 0;
    data['parent'] = this.parent;
    return data;
  }
}
