// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stduent_record/db/local_database.dart';
import 'package:stduent_record/screens/profile_page.dart';

class Studentinfo extends StatefulWidget {
  const Studentinfo({super.key});

  @override
  State<Studentinfo> createState() => _StudentinfoState();
}

class _StudentinfoState extends State<Studentinfo> {
  late List<Map<String, dynamic>> _studentsData = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchStudentsData();
  }

  Future<void> _fetchStudentsData() async {
    List<Map<String, dynamic>> students = await LocalDatabase().readData();
    Timer(const Duration(seconds: 1), () {});
    if (searchController.text.isNotEmpty) {
      students = students
          .where((student) => student['name']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }

    setState(() {
      _studentsData = students;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          title: const Text('Students'),
          centerTitle: true),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, "AddStudent");
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    _fetchStudentsData();
                  });
                },
                decoration: const InputDecoration(
                    hintText: 'Search',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
              ),
              _studentsData.isEmpty
                  ? const SizedBox(
                      height: 600,
                      child: Center(
                        child: Text(
                          'No students available',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 600,
                      child: ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                leading: _studentsData[index]['image'] == null
                                    ? CircleAvatar(
                                        child: Text(
                                            _studentsData[index]['name'][0]),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Image.file(
                                          File(_studentsData[index]['image']),
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return Profile_page(_studentsData[index]);
                                  }));
                                },
                                trailing: IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              title: Text(
                                                  "Delete ${_studentsData[index]['name']}"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("No")),
                                                TextButton(
                                                    onPressed: () async {
                                                      await LocalDatabase()
                                                          .deleteData(
                                                              id: _studentsData[
                                                                  index]['id']);
                                                      Navigator
                                                          .pushNamedAndRemoveUntil(
                                                              context,
                                                              "HomePage",
                                                              (route) => false);
                                                    },
                                                    child: const Text("Yes"))
                                              ]);
                                        });
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                                title: Text(_studentsData[index]['name']),
                                subtitle: _studentsData[index]['phone'] == null
                                    ? Text(_studentsData[index]['name'])
                                    : Text(_studentsData[index]['phone']));
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(
                                height: 10,
                              ),
                          itemCount: _studentsData.length),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
