class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<String> trailers;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
  });
}

// Dữ liệu mẫu [cite: 206, 214]
final List<Movie> sampleMovies = [
  Movie(
    id: 1,
    title: "Dune: Part Two",
    posterUrl: "https://static01.nyt.com/images/2024/03/01/multimedia/01dune-explainer-01-cvzb/01dune-explainer-01-cvzb-superJumbo.jpg?quality=75&auto=webp",
    overview: "Paul Atreides unites with Chani and the Fremen while seeking revenge...",
    genres: ["Sci-Fi", "Adventure", "Drama"],
    rating: 8.6,
    trailers: ["Official Trailer #1", "IMAX Sneak Peek"],
  ),
  Movie(
    id: 2,
    title: "Deadpool & Wolverine",
    posterUrl: "https://www.thestreet.com/.image/w_750,q_auto:good,c_limit/MTY4NjQ3NzUyNzAzNDg1ODQ3/how-deadpool-surprised-everyone-and-destroyed-box-office-records.jpg?arena_f_auto",
    overview: "The multiverse gets messy when Wade Wilson teams up with Wolverine...",
    genres: ["Action", "Comedy"],
    rating: 8.3,
    trailers: ["Red Band Trailer", "Behind the Scenes"],
  ),
];