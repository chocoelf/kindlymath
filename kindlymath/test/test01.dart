import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LikesScreen(),
    );
  }
}

class LikesScreen extends StatelessWidget {
  // 하드코딩된 데이터
  final List<Map<String, dynamic>> posts = [
    {'title': 'Post 1', 'likes': 100},
    {'title': 'Post 2', 'likes': 150},
    {'title': 'Post 3', 'likes': 200},
    {'title': 'Post 4', 'likes': 250},
    {'title': 'Post 5', 'likes': 300},
    {'title': 'Post 6', 'likes': 350},
  ];

  LikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts by Likes'),
      ),
      body: Stack(
        children: [
          // 중간의 스크롤 가능한 텍스트
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: List.generate(
                    50,
                    (index) => Text(
                      'This is some scrollable text. Line $index',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 하단에 고정된 스크롤 뷰
          Positioned(
            left: 0,
            right: 0,
            bottom: 0, // BottomAppBar 높이만큼 여백을 줌
            child: Container(
              height: 150, // 고정된 스크롤 뷰의 높이
              color: Colors.white,
              child: GridView.builder(
                scrollDirection: Axis.horizontal, // 가로로 스크롤
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // 한 줄에 한 개의 항목을 표시
                  childAspectRatio: 1.5, // 항목의 가로 세로 비율
                ),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  var post = posts[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // 버튼 클릭 시 동작
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(post['title']),
                          Text('Likes: ${post['likes']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 50, // BottomAppBar 높이
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
