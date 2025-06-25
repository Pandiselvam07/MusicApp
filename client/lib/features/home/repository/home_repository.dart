import 'dart:io';

import 'package:client/core/constants/server_constants.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  Future<void> uploadSong({required File song, required File thumbnail}) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ServerConstants.serverURL}/song/upload'),
    );
    request
      ..files.addAll([
        await http.MultipartFile.fromPath('song', song.path),
        await http.MultipartFile.fromPath('thumbnail', thumbnail.path),
      ])
      ..fields.addAll({
        'artist': 'The Weekend Starboy',
        'song_name': 'Starboy',
        'hex_code': 'FFFFFF',
      })
      ..headers.addAll({
        'x-auth-token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImI2MjY4N2FkLWVlNDctNDljNy1hNjZjLTM0YmVlOTMxMDVlOCJ9.Hooon88IAKzGdSi14JytfI5ybmxmmVUGXqdgWwjA0Pg',
      });
    final res = await request.send();
    print(res);
  }
}
