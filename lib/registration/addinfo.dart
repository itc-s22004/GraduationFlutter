import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:omg/auth_controller.dart';
import 'package:omg/comp/tag.dart';

import '../utilities/constant.dart';

class AddInfo extends StatefulWidget {
  final String data;

  const AddInfo({super.key, required this.data});

  @override
  _AddInfoState createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
  String? _selectedGender;
  String? _selectedSchool;
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _introductionController = TextEditingController();
  final TextEditingController _schoolNumController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  bool _isButtonEnabled = false;

  @override
  void dispose() {
    _diagnosisController.dispose();
    _introductionController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _selectedGender != null &&
          _selectedSchool != null &&
          _schoolNumController.text.trim().isNotEmpty;
    });
  }

  Future<void> _updateUserData() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.data)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;
          String docId = userDoc.id;

          FirebaseFirestore.instance.collection('users').doc(docId).update({
            'gender': _selectedGender,
            'school': _selectedSchool,
            'diagnosis': "",
            'schoolNumber': _schoolNumController.text.trim(),
            'introduction': _introductionController.text.trim(),
          });

          authController.updateGender(_selectedGender ?? '');
          authController.updateSchool(_selectedSchool ?? '');
          authController.updateDiagnosis(_diagnosisController.text.trim());
          authController.updateSchoolNum(_schoolNumController.text.trim());
          authController.updateIntroduction(_introductionController.text.trim());
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '設定',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.elliptical(90, 30),
            ),
          ),
          backgroundColor: kAppBarBackground,
          elevation: 0,
        ),
        body: Align(
            alignment: Alignment.topCenter,
            child: Stack(children: [
              Container(
                height: 500,
                color: kAppBtmBackground,
              ),
              Container(
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(200),
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Text('email: ${widget.data}'),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      items: ['男性', '女性', 'その他', '無回答'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGender = newValue;
                          _updateButtonState();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: '性別',
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        filled: true,
                        fillColor: Colors.blueGrey.shade50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedSchool,
                      items: [
                        'ITカレッジ沖縄', '外語学院', 'Python', 'JavaScript', 'Java', 'Kotlin', 'Dart', 'HTML/CSS', 'security', '基本情報技術者試験'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSchool = newValue;
                          _updateButtonState();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: '得意な言語',
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        filled: true,
                        fillColor: Colors.blueGrey.shade50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _schoolNumController,
                      decoration: InputDecoration(
                        labelText: '学籍番号',
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Colors.blueGrey.shade50,
                      ),
                      onChanged: (text) {
                        _updateButtonState();
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _introductionController,
                      decoration: InputDecoration(
                        labelText: '自己紹介',
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Colors.blueGrey.shade50,
                      ),
                      maxLines: null,
                      onChanged: (text) {
                        _updateButtonState();
                      },
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(0, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isButtonEnabled
                              ? () async {
                                  await _updateUserData();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Tag(
                                              email: widget.data,
                                              fromEditProf: false
                                          ),
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 10,
                          ),
                          child: const Text(
                            '次へ進む',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ])));
  }
}