import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../models/song_model.dart';
import '../providers/audio_player_provider.dart';

class DetailPage extends StatefulWidget {
  final Song song;
  final List<Song>? playlist;
  final int initialIndex;

  const DetailPage({
    super.key,
    required this.song,
    this.playlist,
    this.initialIndex = 0,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  double? _dragValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AudioPlayerProvider>();
      if (widget.playlist != null && widget.playlist!.isNotEmpty) {
        provider.playSong(
          widget.song,
          playlist: widget.playlist,
          index: widget.initialIndex,
        );
      } else {
        provider.playSong(widget.song);
      }
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = context.watch<AudioPlayerProvider>();
    final player = audioProvider.player;
    final currentSong = audioProvider.currentSong ?? widget.song;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Now Playing', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Hero(
              tag: 'cover_${currentSong.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  currentSong.coverUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.grey[850],
                    child: const Icon(Icons.music_note, size: 80, color: Colors.white54),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              currentSong.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              currentSong.artist,
              style: TextStyle(fontSize: 15, color: Colors.grey[400]),
              textAlign: TextAlign.center,
            ),
            const Spacer(),

            StreamBuilder<Duration>(
              stream: player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final totalDuration = player.duration ?? Duration.zero;
                final maxDuration = totalDuration.inSeconds.toDouble() > 0
                    ? totalDuration.inSeconds.toDouble()
                    : 1.0;

                final currentSliderValue = (_dragValue ?? position.inSeconds.toDouble())
                    .clamp(0.0, maxDuration);

                return Column(
                  children: [
                    Slider(
                      value: currentSliderValue,
                      max: maxDuration,
                      activeColor: const Color(0xFF6366F1),
                      inactiveColor: Colors.white10,
                      onChanged: (v) {
                        setState(() {
                          _dragValue = v;
                        });
                      },
                      onChangeEnd: (v) {
                        audioProvider.seek(Duration(seconds: v.toInt()));
                        setState(() {
                          _dragValue = null;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(Duration(seconds: currentSliderValue.toInt())),
                            style: TextStyle(color: Colors.grey[400], fontSize: 12),
                          ),
                          Text(
                            _formatDuration(totalDuration),
                            style: TextStyle(color: Colors.grey[400], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol Previous
                IconButton(
                  icon: const Icon(Icons.skip_previous_rounded, size: 38, color: Colors.white),
                  onPressed: audioProvider.hasPrevious ? audioProvider.previous : null,
                  disabledColor: Colors.white24,
                ),
                const SizedBox(width: 20),

                // Tombol Play / Pause
                StreamBuilder<PlayerState>(
                  stream: player.playerStateStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data?.playing ?? false;
                    return CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFF6366F1),
                      child: IconButton(
                        icon: Icon(
                          playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          size: 34,
                          color: Colors.white,
                        ),
                        onPressed: audioProvider.togglePlayPause,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 20),

                // Tombol Next
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded, size: 38, color: Colors.white),
                  onPressed: audioProvider.hasNext ? audioProvider.next : null,
                  disabledColor: Colors.white24,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

