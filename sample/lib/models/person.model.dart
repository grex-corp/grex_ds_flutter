import '../enums/parent_worship_type.dart';
import 'knowledge_trail_model.dart';
import 'role.model.dart';

class Person {
  int id;
  String name;
  String? phone;
  Person? leadership;
  DateTime? birthDate;
  bool createUser;
  bool single;
  Uri? avatar;
  Iterable<Role> roles;
  KnowledgeTrail? trail;
  ParentWorshipType fatherType;

  Person({
    required this.id,
    required this.name,
    this.phone,
    this.leadership,
    this.birthDate,
    this.createUser = false,
    this.single = false,
    this.avatar,
    this.roles = const [],
    this.trail,
    this.fatherType = ParentWorshipType.unknown,
  });
}
