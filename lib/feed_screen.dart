import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _page = 0;
  bool _liked = false;

  final List<String> _videos = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://www.pexels.com/es-es/download/video/7656813/',
    'https://www.pexels.com/es-es/download/video/7316975/',
  ];

  final List<String> _descriptions = [
    'Disfruta de los mejores videos',
    'Descubre contenido nuevo 🚀',
    'Video vertical prexel',
    'Vidoe prexel 2',
  ];

  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _loadVideo(0);
  }

  Future<void> _loadVideo(int index) async {
    await _controller?.dispose();

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(_videos[index]),
    );

    _controller = controller;

    await controller.initialize();

    if (!mounted || _controller != controller) return;

    controller.setLooping(true);
    controller.play();

    setState(() {});
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _videos.length,
        onPageChanged: (index) {
          setState(() {
            _page = index;
            _liked = false;
          });
          _loadVideo(index);
        },
        itemBuilder: (context, index) {
          return Stack(
            fit: StackFit.expand,
            children: [
              if (_controller != null &&
                  _page == index &&
                  _controller!.value.isInitialized)
                FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                )
              else
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                      Colors.black54,
                    ],
                  ),
                ),
              ),

              SafeArea(
                child: Stack(
                  children: [
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
                          ),
                        ],
                      ),
                    ),

                    Center(
                      child: IconButton(
                        iconSize: 65,
                        color: Colors.white70,
                        icon: Icon(
                          _controller?.value.isPlaying == true
                              ? Icons.pause_circle
                              : Icons.play_circle,
                        ),
                        onPressed: () {
                          if (_controller == null) return;

                          setState(() {
                            if (_controller!.value.isPlaying) {
                              _controller!.pause();
                            } else {
                              _controller!.play();
                            }
                          });
                        },
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
                          const Icon(
                            Icons.comment,
                            color: Colors.white,
                            size: 35,
                          ),
                          const Text(
                            'Comentar',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          const Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 35,
                          ),
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
            ],
          );
        },
      ),
    );
  }
}
