import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../../core/providers/current_song_notifier.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return ref
        .watch(getFavSongsProvider)
        .when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length + 1,
              itemBuilder: (context, index) {
                if (index == data.length) {
                  return ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UploadSongPage()),
                    ),
                    leading: CircleAvatar(
                      radius: 35,
                      backgroundColor: Pallete.backgroundColor,
                      child: Icon(CupertinoIcons.plus),
                    ),
                    title: Text(
                      'Upload new song',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }
                final song = data[index];

                return ListTile(
                  onTap: () {
                    ref
                        .read(currentSongNotifierProvider.notifier)
                        .updateSong(song);
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(song.thumbnail_url),
                    radius: 35,
                    backgroundColor: Pallete.backgroundColor,
                  ),
                  title: Text(
                    song.song_name,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    song.artist,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                );
              },
            );
          },
          error: (error, st) {
            return Center(child: Text(error.toString()));
          },
          loading: () => Loader(),
        );
  }
}
