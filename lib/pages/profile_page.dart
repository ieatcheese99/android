import 'package:android/models/song_model.dart';
import 'package:android/pages/favorite_page.dart' show FavoritePage;
import 'package:android/providers/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final List<Song> allSongs;
  const ProfilePage({
    super.key,
    required this.allSongs,
  });

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoriteProvider>();
    final likeCount = favProvider.favoriteIds.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundColor: Color(0xFF6366F1),
              backgroundImage: AssetImage('images/images.jpg'),
            ),
            const SizedBox(height: 16),
            const Text('Ieatcheese',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Music Enthusiast',
                style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF151922),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF6366F1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('$likeCount', 'Liked'),
                  Container(
                    width: 1,
                    height: 24,
                    color: const Color(0xFF6366F1),
                  ),
                  _buildStatItem('45', 'Streamed'),
                  Container(
                    width: 1,
                    height: 24,
                    color: const Color(0xFF6366F1),
                  ),
                  _buildStatItem('23', 'Playlist'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildMenuItem(
              Icons.favorite_rounded,
              'Favourite Songs',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritePage(allSongs: allSongs),
                  ),
                );
              },
            ),
            _buildMenuItem(Icons.history_rounded, 'Recently Played'),
            _buildMenuItem(Icons.storage_rounded, 'Clear Cache Data'),
            _buildMenuItem(Icons.settings_rounded, 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6366F1),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Material(
        color: const Color(0xFF151922),
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFF6366F1), size: 22),
          title: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
