import 'package:flutter/material.dart';
import 'package:stduent_record/screens/add_student.dart';
import 'package:stduent_record/screens/student_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(  
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 251, 245, 1000),
      ),
      debugShowCheckedModeBanner: false,
      home: const Studentinfo(),
      routes: {
        "HomePage": (context) => const Studentinfo(),
        "AddStudent": (context) => const Firstpage(),
      },
    );
  }
}
