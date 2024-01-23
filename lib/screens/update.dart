// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stduent_record/db/local_database.dart';

class updatepage extends StatefulWidget {
  final int? id;
  final int index;

  const updatepage({super.key, this.id, required this.index});
  @override
  State<updatepage> createState() => _updatepageState();
}

class _updatepageState extends State<updatepage> {
  final formkey = GlobalKey<FormState>();
  final name = TextEditingController();
  final place = TextEditingController();
  final mail = TextEditingController();
  final phone = TextEditingController();
  String? oldImage;
  // String? _image;

  File? _selectedImage;
  void _setImage(File image) {
    setState(() {
      _selectedImage = image;
    });
  }

  putData() {
    name.text = WholeDataList[widget.index]['name'];
    place.text = WholeDataList[widget.index]['place'];
    mail.text = WholeDataList[widget.index]['mail'];
    phone.text = WholeDataList[widget.index]['phone'];
    oldImage = WholeDataList[widget.index]['image'];
    if (oldImage != null) {
      _selectedImage = File(oldImage!);
    }
  }

  @override
  void initState() {
    putData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Students Record '),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.indigo,
                  maxRadius: 70,
                  child: GestureDetector(
                    onTap: () async {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 150,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.photo_camera),
                                    title: const Text("Camera"),
                                    onTap: () async {
                                      File? pickedImage =
                                          await _pickImageFromCamera();
                                      if (pickedImage != null) {
                                        Navigator.of(context).pop();
                                        _setImage(pickedImage);
                                      }
                                      // _image = _selectedImage?.path;
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text("Gallery"),
                                    onTap: () async {
                                      File? pickedImage =
                                          await _pickImageFromGallery();
                                      if (pickedImage != null) {
                                        Navigator.of(context).pop();
                                        _setImage(pickedImage);
                                      }
                                      // _image = _selectedImage?.path;
                                    },
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: _selectedImage != null
                        ? ClipOval(
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                            ),
                          )
                        : ClipOval(
                            child: _selectedImage != null
                                ? Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                    width: 140,
                                    height: 140,
                                  )
                                : const Text('No Image')),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Name';
                    }
                    return null;
                  },
                  controller: name,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Student Name',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Age';
                    }
                    return null;
                  },
                  controller: place,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Place'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your E-mail';
                    } else if (!value.contains('@gmail.com')) {
                      return 'Enter a Valid E-mail';
                    }
                    return null;
                  },
                  controller: mail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'E-mail',
                      prefixIcon: const Icon(Icons.email_rounded)),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Phone Number';
                    } else if (value.length != 10) {
                      return 'Enter a Valid Phone Number';
                    }
                    return null;
                  },
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone)),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromRGBO(63, 81, 181, 1)),
                      foregroundColor:
                          const MaterialStatePropertyAll(Colors.white)),
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      await LocalDatabase().updateDB(
                          name: name.text,
                          place: place.text,
                          mail: mail.text,
                          phone: phone.text,
                          image: _selectedImage?.path,
                          id: widget.id);
                      Navigator.pushNamedAndRemoveUntil(
                          context, "HomePage", (route) => false);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<File?> _pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }

  Future<File?> _pickImageFromCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }
}
