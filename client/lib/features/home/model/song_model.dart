class SongModel {
  final String id;
  final String song_name;
  final String artist;
  final String thumbnail_url;
  final String song_url;
  final String hex_code;

  //<editor-fold desc="Data Methods">
  const SongModel({
    required this.id,
    required this.song_name,
    required this.artist,
    required this.thumbnail_url,
    required this.song_url,
    required this.hex_code,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SongModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          song_name == other.song_name &&
          artist == other.artist &&
          thumbnail_url == other.thumbnail_url &&
          song_url == other.song_url &&
          hex_code == other.hex_code);

  @override
  int get hashCode =>
      id.hashCode ^
      song_name.hashCode ^
      artist.hashCode ^
      thumbnail_url.hashCode ^
      song_url.hashCode ^
      hex_code.hashCode;

  @override
  String toString() {
    return 'SongModel{' +
        ' id: $id,' +
        ' song_name: $song_name,' +
        ' artist: $artist,' +
        ' thumbnail_url: $thumbnail_url,' +
        ' song_url: $song_url,' +
        ' hex_code: $hex_code,' +
        '}';
  }

  SongModel copyWith({
    String? id,
    String? song_name,
    String? artist,
    String? thumbnail_url,
    String? song_url,
    String? hex_code,
  }) {
    return SongModel(
      id: id ?? this.id,
      song_name: song_name ?? this.song_name,
      artist: artist ?? this.artist,
      thumbnail_url: thumbnail_url ?? this.thumbnail_url,
      song_url: song_url ?? this.song_url,
      hex_code: hex_code ?? this.hex_code,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'song_name': this.song_name,
      'artist': this.artist,
      'thumbnail_url': this.thumbnail_url,
      'song_url': this.song_url,
      'hex_code': this.hex_code,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] ?? '',
      song_name: map['song_name'] ?? '',
      artist: map['artist'] ?? '',
      thumbnail_url: map['thumbnail_url'] ?? '',
      song_url: map['song_url'] ?? '',
      hex_code: map['hex_code'] ?? '',
    );
  }

  //</editor-fold>
}
