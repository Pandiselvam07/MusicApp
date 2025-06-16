class UserModel {
  final String name;
  final String email;
  final String id;

  const UserModel({required this.name, required this.email, required this.id});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          id == other.id);

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ id.hashCode;

  @override
  String toString() {
    return 'UserModel{' +
        ' name: $name,' +
        ' email: $email,' +
        ' id: $id,' +
        '}';
  }

  UserModel copyWith({String? name, String? email, String? id}) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': this.name, 'email': this.email, 'id': this.id};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      id: map['id'] as String,
    );
  }
}
