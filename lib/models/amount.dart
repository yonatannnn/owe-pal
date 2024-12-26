import 'package:owe_pal/models/user.dart';

class Amount {
  String id;
  User user1;
  User user2;
  int netAmount;
  String groupId;

  Amount(
      {required this.id,
      required this.groupId,
      required this.user1,
      required this.user2,
      required this.netAmount});

  factory Amount.fromJson(Map<String, dynamic> json) {
    return Amount(
      id: json['id'],
      netAmount: json['net_amount'],
      groupId: json['group_id'],
      user1: User.fromJson(json['user1']),
      user2: User.fromJson(json['user2']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'net_amount': netAmount,
      'group_id': groupId,
      'user1': user1.toJson(),
      'user2': user2.toJson(),
    };
  }
}
