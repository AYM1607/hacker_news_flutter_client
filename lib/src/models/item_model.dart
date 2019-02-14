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
        descendants = json['descendants'],
        id = json['id'],
        kids = json['kids'],
        score = json['score'],
        time = json['time'],
        title = json['title'],
        type = json['type'],
        url = json['url'],
        deleted = json['deleted'],
        text = json['text'],
        dead = json['dead'],
        parent = json['parent'];

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
}
