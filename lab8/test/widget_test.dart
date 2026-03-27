// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:lab8/services/api_service.dart';
import 'package:lab8/screens/posts_list_screen.dart';

void main() {
  testWidgets('Posts list loads from API', (WidgetTester tester) async {
    final mockClient = MockClient((http.Request request) async {
      return http.Response(
        '[{"userId": 1, "id": 1, "title": "Hello", "body": "World"}]',
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final apiService = ApiService(client: mockClient);

    await tester.pumpWidget(
      MaterialApp(
        home: PostsListScreen(apiService: apiService),
      ),
    );

    // FutureBuilder sẽ hiển thị loading trước khi có dữ liệu.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Chờ Future hoàn tất và UI rebuild.
    await tester.pumpAndSettle();

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('User 1'), findsOneWidget);
  });
}
