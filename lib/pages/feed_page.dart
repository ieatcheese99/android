import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:android/pages/detail_page.dart';
import 'package:android/providers/audio_player_provider.dart';
import '../models/song_model.dart';
import '../widgets/song_card.dart';

enum SortOption { defaultOrder, titleAZ, titleZA, artistAZ, artistZA }

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  SortOption _sortOption = SortOption.defaultOrder;
  String _selectedCategory = 'All';

  // --- LOGIKA FILTER & SORTING ---
  List<Song> get _filteredAndSortedSongs {
    List<Song> songs = _selectedCategory == 'All'
        ? List<Song>.from(sampleSongs)
        : sampleSongs
            .where(
              (song) => song.tag.toLowerCase() == _selectedCategory.toLowerCase(),
            )
            .toList();

    switch (_sortOption) {
      case SortOption.titleAZ:
        songs.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.titleZA:
        songs.sort((a, b) => b.title.compareTo(a.title));
        break;
      case SortOption.artistAZ:
        songs.sort((a, b) => a.artist.compareTo(b.artist));
        break;
      case SortOption.artistZA:
        songs.sort((a, b) => b.artist.compareTo(a.artist));
        break;
      case SortOption.defaultOrder:
        break;
    }
    return songs;
  }

  @override
  Widget build(BuildContext context) {
    final songs = _filteredAndSortedSongs;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Discover Vibes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort_rounded),
            onSelected: (value) => setState(() => _sortOption = value),
            itemBuilder: (context) => const [
              PopupMenuItem(value: SortOption.defaultOrder, child: Text('Default')),
              PopupMenuItem(value: SortOption.titleAZ, child: Text('Title A-Z')),
              PopupMenuItem(value: SortOption.titleZA, child: Text('Title Z-A')),
              PopupMenuItem(value: SortOption.artistAZ, child: Text('Artist A-Z')),
              PopupMenuItem(value: SortOption.artistZA, child: Text('Artist Z-A')),
            ],
          ),
        ],
      ),
      
      // DIBUNGKUS SAFEAREA AGAR TIDAK TERTUTUP BOTTOM NAVIGATION BAR
      body: SafeArea(
        child: Column(
          children: [
            // 1. CATEGORY CHIPS
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = _selectedCategory == category;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      selectedColor: const Color(0xFF6366F1),
                      backgroundColor: const Color(0xFF151922),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[400],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // 2. LIST LAGU (DIBUNGKUS EXPANDED)
            Expanded(
              child: songs.isEmpty
                  ? Center(
                      child: Text(
                        'Tidak ada lagu untuk genre "$_selectedCategory"',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return SongCard(
                          song: song,
                          playlist: songs,
                          index: index,
                        );
                      },
                    ),
            ),

            // 3. MINI PLAYER (MUNCUL OTOMATIS SAAT LAGU DIPUTAR)
            Consumer<AudioPlayerProvider>(
              builder: (context, audioProv, child) {
                // Sembunyikan jika belum ada lagu yang dipilih
                if (audioProv.currentSong == null) {
                  return const SizedBox.shrink();
                }
                
                // Panggil method mini player yang sudah dipisah di bawah
                return _buildMiniPlayer(context, audioProv);
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET MINI PLAYER (DIPISAH AGAR KODE BUILD LEBIH BERSIH) ---
  Widget _buildMiniPlayer(BuildContext context, AudioPlayerProvider audioProv) {
    return GestureDetector(
      // Fitur UX: Tap mini player untuk kembali ke DetailPage
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              song: audioProv.currentSong!,
              playlist: audioProv.playlist.isNotEmpty ? audioProv.playlist : null,
              initialIndex: audioProv.currentIndex,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF252A39), // Warna sedikit lebih terang agar terlihat jelas
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Cover Album
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                audioProv.currentSong!.coverUrl,
                width: 45,
                height: 45,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            
            // Judul & Artis
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    audioProv.currentSong!.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    audioProv.currentSong!.artist,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Tombol Play/Pause
            StreamBuilder<PlayerState>(
              stream: audioProv.player.playerStateStream,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data?.playing ?? false;
                return IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: audioProv.togglePlayPause,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
