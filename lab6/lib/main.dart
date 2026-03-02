import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

// Lab 6.1 - Định nghĩa Model dữ liệu [cite: 297]
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

// Dữ liệu mẫu [cite: 303]
final List<Movie> allMovies = [
  Movie(title: "Dune: Part Two", year: 2024, genres: ["Sci-Fi", "Adventure"], rating: 8.6, posterUrl: "https://www.thestreet.com/.image/w_750,q_auto:good,c_limit/MTY4NjQ3NzUyNzAzNDg1ODQ3/how-deadpool-surprised-everyone-and-destroyed-box-office-records.jpg?arena_f_auto"),
  Movie(title: "Deadpool & Wolverine", year: 2024, genres: ["Action", "Comedy"], rating: 8.3, posterUrl: "https://www.thestreet.com/.image/w_750,q_auto:good,c_limit/MTY4NjQ3NzUyNzAzNDg1ODQ3/how-deadpool-surprised-everyone-and-destroyed-box-office-records.jpg?arena_f_auto"),
  Movie(title: "Inception", year: 2010, genres: ["Sci-Fi", "Action"], rating: 8.8, posterUrl: "https://www.thestreet.com/.image/w_750,q_auto:good,c_limit/MTY4NjQ3NzUyNzAzNDg1ODQ3/how-deadpool-surprised-everyone-and-destroyed-box-office-records.jpg?arena_f_auto"),
  Movie(title: "The Dark Knight", year: 2008, genres: ["Action", "Drama"], rating: 9.0, posterUrl: "https://www.thestreet.com/.image/w_750,q_auto:good,c_limit/MTY4NjQ3NzUyNzAzNDg1ODQ3/how-deadpool-surprised-everyone-and-destroyed-box-office-records.jpg?arena_f_auto"),
  Movie(title: "Interstellar", year: 2014, genres: ["Sci-Fi", "Drama"], rating: 8.7, posterUrl: "https://www.thestreet.com/.image/w_750,q_auto:good,c_limit/MTY4NjQ3NzUyNzAzNDg1ODQ3/how-deadpool-surprised-everyone-and-destroyed-box-office-records.jpg?arena_f_auto"),
];

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 6 - Responsive Movies',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: const GenreScreen(),
    );
  }
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  String searchQuery = ''; // [cite: 314]
  Set<String> selectedGenres = {}; // [cite: 319]
  String selectedSort = "A-Z"; // [cite: 327]

  final List<String> availableGenres = ["Action", "Sci-Fi", "Drama", "Adventure", "Comedy"];

  @override
  Widget build(BuildContext context) {
    // 1. Lọc danh sách phim theo Search và Genre [cite: 331]
    List<Movie> visibleMovies = allMovies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesGenre = selectedGenres.isEmpty ||
          movie.genres.any((g) => selectedGenres.contains(g));
      return matchesSearch && matchesGenre;
    }).toList();

    // 2. Sắp xếp danh sách [cite: 334]
    if (selectedSort == "A-Z") visibleMovies.sort((a, b) => a.title.compareTo(b.title));
    else if (selectedSort == "Z-A") visibleMovies.sort((a, b) => b.title.compareTo(a.title));
    else if (selectedSort == "Rating") visibleMovies.sort((a, b) => b.rating.compareTo(a.rating));
    else if (selectedSort == "Year") visibleMovies.sort((a, b) => b.year.compareTo(a.year));

    return Scaffold(
      appBar: AppBar(title: const Text("Find a Movie")), // [cite: 310]
      body: SafeArea( // [cite: 279, 308]
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar [cite: 313]
              TextField(
                decoration: InputDecoration(
                  hintText: "Search title...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (value) => setState(() => searchQuery = value),
              ),
              const SizedBox(height: 16),

              // Genre Chips sử dụng Wrap [cite: 317, 320]
              const Text("Genres:", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: availableGenres.map((genre) {
                  final isSelected = selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) selectedGenres.add(genre);
                        else selectedGenres.remove(genre);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Sort Dropdown [cite: 325]
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Movies found: ${visibleMovies.length}"),
                  DropdownButton<String>(
                    value: selectedSort,
                    items: ["A-Z", "Z-A", "Year", "Rating"].map((s) =>
                        DropdownMenuItem(value: s, child: Text("Sort by $s"))).toList(),
                    onChanged: (val) => setState(() => selectedSort = val!),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Responsive Movie List sử dụng LayoutBuilder [cite: 336, 338]
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 800) { // Mobile
                      return ListView.builder(
                        itemCount: visibleMovies.length,
                        itemBuilder: (context, index) => MovieCard(movie: visibleMovies[index]),
                      );
                    } else { // Tablet/Web
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: visibleMovies.length,
                        itemBuilder: (context, index) => MovieCard(movie: visibleMovies[index]),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget thẻ Movie Card [cite: 341]
class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(movie.posterUrl, width: 50, fit: BoxFit.cover), // [cite: 342]
        ),
        title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold)), // [cite: 343]
        subtitle: Text("${movie.year} • ⭐ ${movie.rating}"), // [cite: 344]
      ),
    );
  }
}