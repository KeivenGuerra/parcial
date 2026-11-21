
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _page = 0;
  bool _liked = false;

  final List<String> _descriptions = [
    'Disfruta de los mejores videos 🎬',
    'Descubre contenido nuevo 🚀',
    'Comparte tus momentos ✨',
    'Bienvenido a nuestro feed 🔥',
  ];

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 4,
        onPageChanged: (index) {
          setState(() {
            _page = index;
            _liked = false;
          });
        },
        itemBuilder: (context, index) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF241047),
                  Color(0xFF673AB7),
                  Color(0xFF120B20),
                ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.play_circle_fill,
                          size: 100,
                          color: Colors.white70,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'VIDEO ${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Desliza hacia arriba para continuar',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'APP PARCIAL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: _logout,
                          icon: const Icon(Icons.logout, color: Colors.white),
                          tooltip: 'Cerrar sesión',
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 20,
                    right: 85,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FirebaseAuth.instance.currentUser?.displayName ??
                              FirebaseAuth.instance.currentUser?.email ??
                              'Usuario',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _descriptions[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 45,
                    right: 20,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() => _liked = !_liked);
                          },
                          icon: Icon(
                            _liked ? Icons.favorite : Icons.favorite_border,
                            color: _liked ? Colors.red : Colors.white,
                            size: 38,
                          ),
                        ),
                        Text(
                          _liked ? 'Liked' : 'Like',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        const Icon(Icons.comment, color: Colors.white, size: 35),
                        const Text(
                          'Comentar',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        const Icon(Icons.share, color: Colors.white, size: 35),
                        const Text(
                          'Compartir',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
