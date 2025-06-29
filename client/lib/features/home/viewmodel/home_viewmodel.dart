import 'dart:io';
import 'dart:ui';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/model/fav_song_model.dart';
import 'package:client/features/home/repository/home_local_repository.dart';
import 'package:client/features/home/repository/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' show Left, Right;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/song_model.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(Ref ref) async {
  final token = ref.watch(
    currentUserNotifierProvider.select((user) => user!.token),
  );
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token: token);
  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> getFavSongs(Ref ref) async {
  final token = ref.watch(
    currentUserNotifierProvider.select((user) => user!.token),
  );
  final res = await ref
      .watch(homeRepositoryProvider)
      .getAllFavSongs(token: token);
  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedImage,
    required String artist,
    required String songName,
    required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();
    final token = ref.read(currentUserNotifierProvider)?.token;
    final color = rgbToHexcode(selectedColor);
    final res = await _homeRepository.uploadSong(
      selectedAudio: selectedAudio,
      selectedImage: selectedImage,
      artist: artist,
      songName: songName,
      hexCode: color,
      token: token!,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  List<SongModel> getRecentlyPlayedSongs() {
    return _homeLocalRepository.loadSongs();
  }

  Future<void> favSong({required String songId}) async {
    state = const AsyncValue.loading();
    final token = ref.read(currentUserNotifierProvider)?.token;
    final res = await _homeRepository.favSong(token: token!, songId: songId);

    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => _favSongSuccess(r, songId),
    };
    print(val);
  }

  AsyncValue _favSongSuccess(bool isFavorite, String songId) {
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);

    if (isFavorite) {
      userNotifier.addUserModel(
        ref
            .read(currentUserNotifierProvider)!
            .copyWith(
              favorites: [
                ...ref.read(currentUserNotifierProvider)!.favorites,
                FavSongModel(id: '', song_id: songId, user_id: ''),
              ],
            ),
      );
    } else {
      userNotifier.addUserModel(
        ref
            .read(currentUserNotifierProvider)!
            .copyWith(
              favorites: ref
                  .read(currentUserNotifierProvider)!
                  .favorites
                  .where((fav) => fav.song_id != songId)
                  .toList(),
            ),
      );
    }
    ref.invalidate(getFavSongsProvider);
    return state = AsyncValue.data(isFavorite);
  }
}
