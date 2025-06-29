class FavSongModel {
  final String id;
  final String song_id;
  final String user_id;

  const FavSongModel({
    required this.id,
    required this.song_id,
    required this.user_id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavSongModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          song_id == other.song_id &&
          user_id == other.user_id);

  @override
  int get hashCode => id.hashCode ^ song_id.hashCode ^ user_id.hashCode;

  @override
  String toString() {
    return 'FavSongModel{' +
        ' id: $id,' +
        ' song_id: $song_id,' +
        ' user_id: $user_id,' +
        '}';
  }

  FavSongModel copyWith({String? id, String? song_id, String? user_id}) {
    return FavSongModel(
      id: id ?? this.id,
      song_id: song_id ?? this.song_id,
      user_id: user_id ?? this.user_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': this.id, 'song_id': this.song_id, 'user_id': this.user_id};
  }

  factory FavSongModel.fromMap(Map<String, dynamic> map) {
    return FavSongModel(
      id: map['id'] as String,
      song_id: map['song_id'] as String,
      user_id: map['user_id'] as String,
    );
  }
}
