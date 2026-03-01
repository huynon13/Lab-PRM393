import 'ex1.dart';
import 'ex2.dart';
import 'ex3.dart';
import 'ex4.dart';
import 'ex5.dart';

void main() async {
  runExercise1();
  runExercise2();
  runExercise3();
  runExercise4();
  await runExercise5(); // Đợi bài 5 xong vì nó có async
}