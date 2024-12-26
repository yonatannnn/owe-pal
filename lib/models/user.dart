class User {
  late final String uid;
  final String name;
  final List<String> groupIds;

  User({
    required this.uid,
    required this.name,
    required this.groupIds,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['id'],
      name: json['name'],
      groupIds: List<String>.from(json['group_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'name': name,
      'group_id': groupIds,
    };
  }
}
