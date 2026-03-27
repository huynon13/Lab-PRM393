import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/api_service.dart';

class PostsListScreen extends StatefulWidget {
  const PostsListScreen({
    super.key,
    this.apiService,
  });

  /// Cho phép inject service để dễ test (không gọi network thật).
  final ApiService? apiService;

  @override
  State<PostsListScreen> createState() => _PostsListScreenState();
}

class _PostsListScreenState extends State<PostsListScreen> {
  late Future<List<PostModel>> _futurePosts;
  late final ApiService _apiService;
  bool _ownApiService = false;

  @override
  void initState() {
    super.initState();
    if (widget.apiService != null) {
      _apiService = widget.apiService!;
      _ownApiService = false;
    } else {
      _apiService = ApiService();
      _ownApiService = true;
    }

    _futurePosts = _apiService.fetchPosts();
  }

  @override
  void dispose() {
    if (_ownApiService) {
      _apiService.close();
    }
    super.dispose();
  }

  void _retry() {
    setState(() {
      _futurePosts = _apiService.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API-powered Posts'),
      ),
      body: FutureBuilder<List<PostModel>>(
        future: _futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Something went wrong',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      snapshot.error.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _retry,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final posts = snapshot.data;
          if (posts == null || posts.isEmpty) {
            return const Center(child: Text('No data'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                leading: Text(post.id.toString()),
                title: Text(post.title),
                subtitle: Text('User ${post.userId}'),
              );
            },
          );
        },
      ),
    );
  }
}

