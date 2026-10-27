import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String id;
  final String title;
  final String artist;
  final String audioUrl;
  final String mediaUrl;
  final String imageUrl;
  final String tag;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    this.audioUrl = '',
    this.mediaUrl = '',
    this.imageUrl = '',
    required this.tag,
  });

  // Getter kompatibilitas dengan widget/halaman yang memanggil coverUrl
  String get coverUrl => imageUrl;

  factory Song.fromFirestore(DocumentSnapshot document) {
    final data = (document.data() as Map<String, dynamic>?) ?? {};

    return Song(
      id: document.id,
      title: data['title']?.toString().trim() ?? 'Tanpa Judul',
      artist: data['artist']?.toString().trim() ?? 'Unknown Artist',
      audioUrl: data['audioUrl']?.toString().trim() ?? '',
      mediaUrl: data['mediaUrl']?.toString().trim() ?? '',
      imageUrl: (data['imageUrl'] ?? data['coverUrl'])?.toString().trim() ?? '',
      tag: data['tag']?.toString().trim() ?? 'Other',
    );
  }

  factory Song.fromMap(Map<String, dynamic> map, {String? id}) {
    return Song(
      id: id ?? map['id']?.toString().trim() ?? '',
      title: map['title']?.toString().trim() ?? 'Tanpa Judul',
      artist: map['artist']?.toString().trim() ?? 'Unknown Artist',
      audioUrl: map['audioUrl']?.toString().trim() ?? '',
      mediaUrl: map['mediaUrl']?.toString().trim() ?? '',
      imageUrl: (map['imageUrl'] ?? map['coverUrl'])?.toString().trim() ?? '',
      tag: map['tag']?.toString().trim() ?? 'Other',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'artist': artist,
      'audioUrl': audioUrl,
      'mediaUrl': mediaUrl,
      'imageUrl': imageUrl,
      'tag': tag,
    };
  }

  Map<String, dynamic> toMap() => toFirestore();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Song && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

const List<String> categories = [
  'All',
  'Trending',
  'Popular',
  'Relax',
  'Synthwave',
];

final List<Song> sampleSongs = [
  const Song(
    id: '1',
    title: 'Self Aware',
    artist: 'The 1975',
    imageUrl: 'https://picsum.photos/id/145/800/600',
    tag: 'Trending',
    audioUrl: 'audio/SelfAware.mp3',
  ),
  const Song(
    id: '2',
    title: 'Jigsaw Falling Into Place',
    artist: 'Radiohead',
    imageUrl: 'https://picsum.photos/id/1025/800/600',
    tag: 'Popular',
    audioUrl: 'audio/JigsawFallingIntoPlace.mp3',
  ),
  const Song(
    id: '3',
    title: 'Lost Train',
    artist: 'Indie Chill',
    imageUrl: 'https://picsum.photos/id/1043/800/600',
    tag: 'Relax',
    audioUrl: 'audio/LostTrain.mp3',
  ),
  const Song(
    id: '4',
    title: 'Cyberpunk Synthwave',
    artist: 'Neon Vibe Studio',
    imageUrl: 'https://picsum.photos/id/1067/800/600',
    audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    tag: 'Synthwave',
  ),
  const Song(
    id: '5',
    title: 'Acoustic Coffee Break',
    artist: 'Indie Chill',
    imageUrl: 'https://picsum.photos/id/225/800/600',
    tag: 'Relax',
    audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
  ),
];