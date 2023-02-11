import 'package:flutter/foundation.dart';
import 'package:test_audio/notifiers/play_button_notifier.dart';
import 'package:test_audio/notifiers/progress_notifier.dart';
import 'package:test_audio/services/playlist_repository.dart';
import 'package:audio_service/audio_service.dart';
import 'package:test_audio/services/service_locator.dart';

class PageManager {
  // Listeners: Updates going to the UI
  final _audioHandler = getIt<AudioHandler>();
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final progressNotifier = ProgressNotifier();
  final playButtonNotifier = PlayButtonNotifier();


  // Events: Calls coming from the UI
  void init() async {
    await _loadPlaylist();
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
  }

  Future<void> _loadPlaylist() async {
    final songRepository = getIt<PlaylistRepository>();
    final playlist = await songRepository.fetchInitialPlaylist();
    final mediaItems = playlist
        .map((song) => MediaItem(
      id: song['id'] ?? '',
      title: song['title'] ?? '',
      extras: {'url': song['url']},
    ))
        .toList();
    _audioHandler.addQueueItems(mediaItems);
  }

  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) return;
      final newList = playlist.map((item) => item.title).toList();
      playlistNotifier.value = newList;
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }


  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();
  void seek(Duration position) {}
  void dispose() {}
}