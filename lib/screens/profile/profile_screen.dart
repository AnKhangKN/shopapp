import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/models/user_model.dart';
import 'package:shopapp/services/profile_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final baseUrl = dotenv.env['API_BASE_URL'];
  final _userServices = ProfileServices();

  UserModel? user;

  Future<void> getDetailUser() async {
    try {
      final res = await _userServices.getDetail();

      setState(() {
        user = res;
      });

      print('user ${user?.userName}' );

      
      
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    getDetailUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://th.bing.com/th/id/R.8124f887824be033b0f103ba7c0650fb?rik=TGa71od4KhLxqw&riu=http%3a%2f%2fimg02.deviantart.net%2fb1da%2fi%2f2006%2f023%2f7%2f9%2fcapybara_swimming_by_henrieke.jpg&ehk=gNmSSh7U%2fscxQgqEU%2bb6GAbaWefl48MA4REMlo0mzCQ%3d&risl=&pid=ImgRaw&r=0',
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -90,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 70.0,
                          backgroundImage: (user?.image != null)
                              ? NetworkImage('${dotenv.env['SHOW_IMAGE_BASE_URL']}/avatar/${user!.image}')
                              : null,
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        user?.userName ?? 'Chưa có tên',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),

            const SizedBox(height: 150),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          context.push('/profile/update');
                        },
                        child: Container(
                          height: 85,
                          alignment: Alignment.center,
                          child: const Text("Thông tin"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Material(
                      child: InkWell(
                        onTap: () => context.push('/cart'),
                        child: Container(
                          height: 85,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const Center(child: Text("Gio hang")),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Material(
                      child: InkWell(
                        onTap: () => context.push('/profile/history'),
                        child: Container(
                          height: 85,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const Center(child: Text("Lich su")),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Material(
                      child: InkWell(
                        onTap: () => context.push('/profile/security'),
                        child: Container(
                          height: 85,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const Center(child: Text("Bảo mật")),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
