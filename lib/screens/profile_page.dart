// ignore_for_file: camel_case_types

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stduent_record/db/local_database.dart';
import 'package:stduent_record/screens/update.dart';

class Profile_page extends StatefulWidget {
  final Map<String, dynamic> studentData;
  const Profile_page(this.studentData,{super.key});

  @override
  State<Profile_page> createState() => _Profile_pageState();
}

class _Profile_pageState extends State<Profile_page> {
  void getdata() async {
    await LocalDatabase().readData();
    Timer(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        actions: [
          IconButton(
              onPressed: () {
                int studentIndex = WholeDataList.indexWhere((student) =>
        student['id'] == widget.studentData['id']);
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return updatepage(
                    id: widget.studentData['id'],
                    index: studentIndex,
                    // index: widget.index,
                  );
                }));
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 90,
                  child:widget.studentData['image'] == null
                      ? CircleAvatar(
                          radius: 90,
                          child: Text(
                            widget.studentData['name'][0],
                            style: const TextStyle(fontSize: 100),
                          ))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(150),
                          child: Image.file(
                            File(widget.studentData['image']),
                            width: 250,
                            height: 250,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                widget.studentData['name'],
                style: const TextStyle(fontSize: 35),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Card(
                  color: const Color.fromARGB(248, 240, 232, 236),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(children: [
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: Text(widget.studentData['phone']),
                      ),
                      ListTile(
                        leading: const Icon(Icons.mail),
                        title: Text(widget.studentData['mail']),
                      ),
                      ListTile(
                        leading: const Icon(Icons.place),
                        title: Text(widget.studentData['place']),
                      ),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
