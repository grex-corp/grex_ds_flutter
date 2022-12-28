import 'role.model.dart';

class Person {
  int id;
  String name;
  Person? leadership;
  DateTime? birthDate;
  bool createUser;
  bool single;
  Uri? avatar;
  Iterable<Role> roles;

  Person({
    required this.id,
    required this.name,
    this.leadership,
    this.birthDate,
    this.createUser = false,
    this.single = false,
    this.avatar,
    this.roles = const [],
  });
}
