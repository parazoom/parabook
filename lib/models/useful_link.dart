class UsefulLink {
  final int? id;
  final String title;
  final String url;

  UsefulLink({this.id, required this.title, required this.url});

  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'url': url};

  factory UsefulLink.fromMap(Map<String, dynamic> m) =>
      UsefulLink(id: m['id'], title: m['title'], url: m['url']);
}
