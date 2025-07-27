import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopapp/services/profile_services.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  File? _imageFile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  void _updateUserInfo() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    print('Tên: $name, Email: $email');
    // Gọi API cập nhật thông tin người dùng ở đây
  }

  void _updateAvatar() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn ảnh trước.")),
      );
      return;
    }

    try {
      final response = await ProfileServices().updateAvatar(_imageFile!);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cập nhật ảnh đại diện thành công!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Thất bại: ${response.statusMessage}")),
        );
      }
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cập nhật thông tin")),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _imageFile != null
                      ? FileImage(_imageFile!)
                      : const NetworkImage(
                    'https://th.bing.com/th/id/R.8124f887824be033b0f103ba7c0650fb?rik=TGa71od4KhLxqw&riu=http%3a%2f%2fimg02.deviantart.net%2fb1da%2fi%2f2006%2f023%2f7%2f9%2fcapybara_swimming_by_henrieke.jpg&ehk=gNmSSh7U%2fscxQgqEU%2bb6GAbaWefl48MA4REMlo0mzCQ%3d&risl=&pid=ImgRaw&r=0',
                  ) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Chọn ảnh từ thư viện"),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nhập tên',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _updateAvatar,
              child: const Text("Cập nhật ảnh đại diện"),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _updateUserInfo,
              child: const Text("Cập nhật thông tin cá nhân"),
            ),
          ],
        ),
      ),
    );
  }
}
