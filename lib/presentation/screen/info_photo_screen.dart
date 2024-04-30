import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/presentation/screen/info_pay_screen.dart';
import 'package:image_picker/image_picker.dart';

class InfoPhotoScreen extends StatefulWidget {
  const InfoPhotoScreen({super.key});

  @override
  State<InfoPhotoScreen> createState() => _InfoPhotoScreenState();
}

class _InfoPhotoScreenState extends State<InfoPhotoScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image; // Variable to store the chosen image
  final picker = ImagePicker();

  bool get _isKeyboardVisible {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery); // Choose an image from the gallery

    setState(() {
      if (pickedFile != null) {
        _image = File(
            pickedFile.path); // Store the path of the selected image in _image
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 사진 설정'),
        backgroundColor: Color(0xFFC4E6F3),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Colors.black,
              Colors.lightBlue,
            ],
          ),
        ),
        child: Form(
          key: _formKey, // Form의 상태를 관리하기 위한 key
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(55),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            '사진 선택하기',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  width: 100,
                  height: 100, // Height of the rectangle
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Default background color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _image == null
                      ? Icon(Icons.add_photo_alternate,
                          size: 100,
                          color: Colors
                              .grey[700]) // Display icon if no image is present
                      : ClipRRect(
                          // Display the image if present
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _image!,
                            fit: BoxFit
                                .cover, // Set the image to fill the container
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 95,
              ),
              Visibility(
                visible: !_isKeyboardVisible,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(240, 240),
                    backgroundColor: const Color(0xFFECE6CC),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InfoPayScreen(),
                        ),
                      );
                    } else {
                      // 입력값이 유효하지 않은 경우 팝업 메시지를 표시합니다.
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('알림'),
                          content: const Text('이름을 입력해주세요'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('확인'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '다음 설정',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 50,
                        color: Colors.deepPurpleAccent,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
