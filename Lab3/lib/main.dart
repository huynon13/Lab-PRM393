import 'dart:async';

// ==========================================================
// Exercise 1 – Product Model & Repository [cite: 76]
// Goal: Understand Futures and Streams [cite: 77]
// ==========================================================
class Product {
  final int id;
  final String name;
  final double price;
  Product(this.id, this.name, this.price); // [cite: 78]
}

class ProductRepository {
  // Trả về danh sách sản phẩm sau 1 giây (Future) [cite: 80]
  Future<List<Product>> getAll() async {
    await Future.delayed(Duration(seconds: 1));
    return [Product(1, 'Laptop', 1500.0), Product(2, 'Phone', 800.0)];
  }

  // Stream để cập nhật sản phẩm thời gian thực [cite: 81]
  final _controller = StreamController<Product>.broadcast(); // [cite: 82]
  Stream<Product> liveAdded() => _controller.stream;

  void addProduct(Product p) {
    _controller.add(p); // Phát sản phẩm mới vào stream [cite: 82]
  }
}

// ==========================================================
// Exercise 2 – User Repository with JSON [cite: 84]
// Goal: Practice JSON serialization / deserialization [cite: 85]
// ==========================================================
class User {
  String name, email;
  // Factory constructor để tạo User từ Map (JSON) [cite: 86]
  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];
}

Future<List<User>> fetchUsers() async {
  // Giả lập dữ liệu JSON nhận được từ API [cite: 87]
  var rawJson = [
    {'name': 'Huy', 'email': 'huy@example.com'},
    {'name': 'Dac', 'email': 'dac@example.com'}
  ];
  // Parse JSON sang List<User> [cite: 88]
  return rawJson.map((json) => User.fromJson(json)).toList();
}

// ==========================================================
// Exercise 3 – Async + Microtask Debugging [cite: 90]
// Goal: Differentiate microtask and event queues [cite: 91]
// ==========================================================
void runAsyncDebug() {
  print('\n--- Exercise 3: Execution Order ---');
  print('1. Start (Main sync)'); // [cite: 93]

  // Future được đưa vào Event Queue [cite: 92]
  Future(() => print('4. Event Queue (Future)'));

  // Microtask có độ ưu tiên cao hơn Event Queue [cite: 92]
  scheduleMicrotask(() => print('3. Microtask Queue'));

  print('2. End (Main sync)'); // [cite: 93]
  // Giải thích: Microtask chạy ngay sau khi code đồng bộ kết thúc
  // và trước khi Event Queue bắt đầu. [cite: 94]
}

// ==========================================================
// Exercise 4 – Stream Transformation [cite: 95]
// Goal: Use functional stream operators [cite: 96]
// ==========================================================
void runStreamTransform() {
  print('\n--- Exercise 4: Stream Transformation ---');
  // Tạo stream từ 1 đến 5 [cite: 97]
  var numberStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  numberStream
      .map((n) => n * n)      // Bình phương giá trị [cite: 98]
      .where((n) => n % 2 == 0) // Lọc lấy số chẵn [cite: 99]
      .listen((val) => print('Processed value: $val')); // [cite: 100]
}

// ==========================================================
// Exercise 5 – Factory Constructors & Cache [cite: 101]
// Goal: Show how factory constructors implement caching [cite: 102]
// ==========================================================
class Settings {
  static final Settings _instance = Settings._internal(); // Singleton instance [cite: 104]

  // Private constructor [cite: 103]
  Settings._internal();

  // Factory constructor luôn trả về duy nhất 1 instance [cite: 104]
  factory Settings() {
    return _instance;
  }
}

void verifySingleton() {
  print('\n--- Exercise 5: Factory & Singleton ---');
  var s1 = Settings();
  var s2 = Settings();
  // Kiểm tra xem hai biến có cùng trỏ tới một vùng nhớ không
  print('S1 and S2 are identical: ${identical(s1, s2)}'); // Expected: true
}

// ==========================================================
// MAIN FUNCTION TO RUN ALL [cite: 74]
// ==========================================================
void main() async {
  print('=== LAB 3: ADVANCED DART ===');

  // Chạy bài 3 trước để thấy thứ tự in
  runAsyncDebug();

  // Chạy bài 4
  runStreamTransform();

  // Chạy bài 5
  verifySingleton();

  // Chạy bài 2: JSON
  var users = await fetchUsers();
  users.forEach((u) => print('User parsed: ${u.name} - ${u.email}')); // [cite: 89]

  // Chạy bài 1: Repo & Stream
  var repo = ProductRepository();
  repo.liveAdded().listen((p) => print('New Live Product: ${p.name}')); // [cite: 81]

  var allProducts = await repo.getAll(); // [cite: 83]
  print('All products loaded: ${allProducts.length}');

  repo.addProduct(Product(3, 'Tablet', 500.0)); // Kích hoạt stream liveAdded
}