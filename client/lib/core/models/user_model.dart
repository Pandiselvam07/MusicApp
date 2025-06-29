import 'package:client/features/home/model/fav_song_model.dart';

class UserModel {
  final String name;
  final String email;
  final String id;
  final String token;
  final List<FavSongModel> favorites;

  const UserModel({
    required this.name,
    required this.email,
    required this.id,
    required this.token,
    required this.favorites,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          id == other.id &&
          token == other.token &&
          favorites == other.favorites);

  @override
  int get hashCode =>
      name.hashCode ^
      email.hashCode ^
      id.hashCode ^
      token.hashCode ^
      favorites.hashCode;

  @override
  String toString() {
    return 'UserModel{' +
        ' name: $name,' +
        ' email: $email,' +
        ' id: $id,' +
        ' token: $token,' +
        ' favorites: $favorites,' +
        '}';
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? id,
    String? token,
    List<FavSongModel>? favorites,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      token: token ?? this.token,
      favorites: favorites ?? this.favorites,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'email': this.email,
      'id': this.id,
      'token': this.token,
      'favorites': this.favorites,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      id: map['id'] ?? '',
      token: map['token'] ?? '',
      favorites: List<FavSongModel>.from(
        (map['favorites'] ?? []).map(
          (x) => FavSongModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
