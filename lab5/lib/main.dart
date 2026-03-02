import 'package:flutter/material.dart';
import 'movie_model.dart';
import 'movie_detail.dart';

void main() => runApp(const MovieApp());

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Movies")),
      // Sử dụng ListView.builder để hiển thị danh sách phim [cite: 215]
      body: ListView.builder(
        itemCount: sampleMovies.length,
        itemBuilder: (context, index) {
          final movie = sampleMovies[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(movie.posterUrl, width: 80, fit: BoxFit.cover),
              title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("⭐ ${movie.rating} • ${movie.genres.join(', ')}"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Điều hướng sang màn hình chi tiết [cite: 215]
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}