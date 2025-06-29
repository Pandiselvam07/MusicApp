import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/current_song_notifier.dart';
import '../../../../core/providers/current_user_notifier.dart';
import '../../viewmodel/home_viewmodel.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.watch(currentSongNotifierProvider.notifier);
    final userFavorite = ref.watch(
      currentUserNotifierProvider.select((data) => data!.favorites),
    );
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [hexToColor(currentSong!.hex_code), const Color(0xff121212)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Scaffold(
        backgroundColor: Pallete.transparentColor,
        appBar: AppBar(
          backgroundColor: Pallete.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/pull-down-arrow.png',
                  color: Pallete.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Hero(
                  tag: 'music-img',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(currentSong!.thumbnail_url),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.song_name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Pallete.whiteColor,
                            ),
                          ),
                          Text(
                            currentSong.artist,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Pallete.subtitleText,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () async {
                          await ref
                              .read(homeViewModelProvider.notifier)
                              .favSong(songId: currentSong.id);
                        },
                        icon: Icon(
                          userFavorite
                                  .where((fav) => fav.song_id == currentSong.id)
                                  .toList()
                                  .isNotEmpty
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  StreamBuilder(
                    stream: songNotifier.audioPlayer!.positionStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      }
                      final position = snapshot.data;
                      final duration = songNotifier.audioPlayer!.duration;
                      double sliderValue = 0.0;
                      if (duration != null && position != null) {
                        sliderValue =
                            position.inMilliseconds / duration.inMilliseconds;
                      }

                      return Column(
                        children: [
                          StatefulBuilder(
                            builder: (context, setState) => SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 4,
                                overlayShape: SliderComponentShape.noOverlay,
                                thumbColor: Pallete.whiteColor,
                                activeTrackColor: Pallete.whiteColor,
                                inactiveTrackColor: Pallete.whiteColor
                                    .withOpacity(0.110),
                              ),
                              child: Slider(
                                min: 0,
                                max: 1,
                                value: sliderValue,
                                onChanged: (val) {
                                  setState(() {
                                    sliderValue = val;
                                  });
                                },
                                onChangeEnd: (val) {
                                  songNotifier.seek(val);
                                },
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${position?.inMinutes}:${(position?.inSeconds ?? 0) < 10 ? '0${position?.inSeconds}' : position?.inSeconds}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Pallete.subtitleText,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                '${duration?.inMinutes}:${(duration?.inSeconds ?? 0) < 10 ? '0${duration?.inSeconds}' : duration?.inSeconds}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Pallete.subtitleText,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/images/shuffle.png',
                                  color: Pallete.whiteColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/images/previous-song.png',
                                  color: Pallete.whiteColor,
                                ),
                              ),
                              IconButton(
                                onPressed: songNotifier.playPause,
                                icon: Icon(
                                  songNotifier.isPlaying
                                      ? CupertinoIcons.pause_circle_fill
                                      : CupertinoIcons.play_circle_fill,
                                  size: 80,
                                  color: Pallete.whiteColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/images/next-song.png',
                                  color: Pallete.whiteColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/images/repeat.png',
                                  color: Pallete.whiteColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/images/connect-device.png',
                                  color: Pallete.whiteColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/images/playlist.png',
                                  color: Pallete.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
