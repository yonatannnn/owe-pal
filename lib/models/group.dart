class Group {
  String id;
  String name;
  List<String> usersId;

  Group({
    required this.id,
    required this.name,
    required this.usersId,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      usersId: List<String>.from(json['usersId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'usersId': usersId,
    };
  }
}
