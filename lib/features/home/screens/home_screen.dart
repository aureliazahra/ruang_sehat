import 'package:flutter/material.dart';
import 'package:ruang_sehat/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 16),
          child: Row(
            children: [
              //profile
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/profile.jpg',
                  fit: BoxFit.cover,
                  width: size.width / 8,
                  height: size.width / 8,
                ),
              ),
              SizedBox(width: 12),
              //username
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, Moci',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'How are you feeling today?',
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                ],
              ),
              Spacer(),
              //Overlay Menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, size: 20,),
                offset: const Offset(0, 50),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                color: Colors.white,
                onSelected: (value) {
                  if (value == 'logout') {
                    Navigator.pushReplacementNamed(context, '/auth');
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 16, color: AppColors.error,),
                        SizedBox(width: 8),
                        Text('Logout', style: TextStyle(color: AppColors.error),),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        
      ),
      body: Center(child: Text('Welcome to the Home Screen!')),
    );
  }
}
