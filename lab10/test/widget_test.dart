import 'package:flutter_test/flutter_test.dart';
import 'package:lab10/main.dart';

void main() {
  testWidgets('Hiển thị màn hình đăng nhập ban đầu', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('Lab 10 - Đăng nhập'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
  });
}
