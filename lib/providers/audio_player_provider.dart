import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';

class AudioPlayerProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  List<Song> _playlist = [];
  int _currentIndex = 0;
  Song? _currentSong;

  AudioPlayer get player => _player;
  Song? get currentSong => _currentSong;
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  bool get isPlaying => _player.playing;

  bool get hasPrevious => _playlist.isNotEmpty && _currentIndex > 0;
  bool get hasNext => _playlist.isNotEmpty && _currentIndex < _playlist.length - 1;

  Future<void> playSong(Song song, {List<Song>? playlist, int? index}) async {
    if (playlist != null && playlist.isNotEmpty) {
      _playlist = playlist;
      _currentIndex = index ?? playlist.indexWhere((s) => s.id == song.id);
      if (_currentIndex == -1) _currentIndex = 0;
    }

    // Jika lagu yang sama masih diputar, tidak perlu reload audio
    if (_currentSong?.id == song.id) {
      if (!_player.playing) _player.play();
      return;
    }

    try {
      _currentSong = song;
      notifyListeners();

      if (song.audioUrl.startsWith('http://') || song.audioUrl.startsWith('https://')) {
        await _player.setUrl(song.audioUrl);
      } else {
        await _player.setAsset(song.audioUrl);
      }
      await _player.play();
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  Future<void> next() async {
    if (hasNext) {
      _currentIndex++;
      await playSong(_playlist[_currentIndex]);
    }
  }

  Future<void> previous() async {
    if (_player.position.inSeconds > 3) {
      seek(Duration.zero);
    } else if (hasPrevious) {
      _currentIndex--;
      await playSong(_playlist[_currentIndex]);
    } else {
      seek(Duration.zero);
    }
  }

  void togglePlayPause() {
    _player.playing ? _player.pause() : _player.play();
  }

  void seek(Duration position) {
    _player.seek(position);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

