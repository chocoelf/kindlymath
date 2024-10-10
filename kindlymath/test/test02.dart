import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class User {
  String? name;
  String? address;
  User(this.name, this.address);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/one',
      routes: {
        '/one': (context) => const HomeScreen()
        // '/three': (context) => ThreeScreen(),
        // '/four': (context) => FourScreen()
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/job') {
          return MaterialPageRoute(
              builder: (context) => const JobScreen(), settings: settings);
        } else if (settings.name == '/game') {
          return MaterialPageRoute(
              builder: (context) => const GameScreen(), settings: settings);
        } else if (settings.name == '/chatbot') {
          return MaterialPageRoute(
              builder: (context) => const ChatbotScreen(), settings: settings);
        } else if (settings.name == '/detail') {
          return MaterialPageRoute(
              builder: (context) => const DetailScreen(), settings: settings);
        }
        return null;
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      // 홈 버튼을 눌렀을 때 홈 화면으로 이동
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Selected Index: $_selectedIndex'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/job', arguments: {
                  'user': User('John Doe', '123 Main St'),
                });
              },
              child: const Text('Job'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/game', arguments: {
                  'user': User('John Doe', '123 Main St'),
                });
              },
              child: const Text('Game'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/chatbot', arguments: {
                  'user': User('John Doe', '123 Main St'),
                });
              },
              child: const Text('Chatbot'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  _JobScreenState createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _selectedGrade1;
  String? _selectedGrade2;
  String? _selectedGrade3;

  final List<String> _grades = [
    '중1',
    '중2',
    '중3',
    '고1',
    '고2',
    '고3',
  ];

  List<String> _uniqueValues = [];
  List<String> _uniqueValues2 = [];
  List<String> _uniqueValues3 = [];

  @override
  void initState() {
    super.initState();
    _fetchUniqueValues();
  }

  Future<void> _fetchUniqueValues() async {
    final querySnapshot = await _firestore.collection('data').get();

    // question_topic_name 필드의 고유 값 가져오기
    final allValues1 = querySnapshot.docs
        .map((doc) => doc['question_topic_name'] as String)
        .toList();
    final uniqueValues1 = allValues1.toSet().toList(); // 중복 제거

    // question_step 필드의 고유 값 가져오기
    final allValues2 = querySnapshot.docs
        .map((doc) => doc['question_step'] as String)
        .toList();
    final uniqueValues2 = allValues2.toSet().toList(); // 중복 제거

    // question_difficulty 필드의 고유 값 가져오기
    final allValues3 = querySnapshot.docs
        .map((doc) => doc['question_difficulty'] as int)
        .toList();
    final uniqueValues3 = allValues3.toSet().toList(); // 중복 제거

    setState(() {
      _uniqueValues = uniqueValues1;
      _uniqueValues2 = uniqueValues2;
      _uniqueValues3 = uniqueValues3.map((e) => e.toString()).toList();

      _selectedGrade1 = _uniqueValues2.isNotEmpty ? _uniqueValues2[0] : null;
      _selectedGrade2 = _uniqueValues3.isNotEmpty ? _uniqueValues3[0] : null;
      _selectedGrade3 = _uniqueValues.isNotEmpty ? _uniqueValues[0] : null;
    });
  }

  Query _buildQuery() {
    Query query = _firestore.collection('data');

    if (_selectedGrade1 != null) {
      query = query.where('question_step', isEqualTo: _selectedGrade1);
    }

    if (_selectedGrade2 != null) {
      try {
        int parsedGrade2 = int.parse(_selectedGrade2!);
        query = query.where('question_difficulty', isEqualTo: parsedGrade2);
      } catch (e) {
        print("Error parsing _selectedGrade2: $e");
      }
    }

    if (_selectedGrade3 != null) {
      query = query.where('question_topic_name', isEqualTo: _selectedGrade3);
    }

    return query;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtered Grid View Example'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 25),
              const Text('학년: ',
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              SizedBox(
                width: 125,
                height: 50,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedGrade1,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGrade1 = newValue;
                    });
                  },
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  items: _uniqueValues2
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 50),
              const Text('단원: ',
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              SizedBox(
                width: 125,
                height: 50,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedGrade2,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGrade2 = newValue;
                    });
                  },
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  items: _uniqueValues3
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 25),
              const Text('개념: ',
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              SizedBox(
                width: 350,
                height: 50,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedGrade3,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGrade3 = newValue;
                    });
                  },
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  items: _uniqueValues
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _buildQuery().snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                final data = snapshot.data!.docs;

                return CustomScrollView(
                  slivers: [
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, // 열의 수를 설정
                        mainAxisSpacing: 10, // 아이템 간의 세로 간격
                        crossAxisSpacing: 10, // 아이템 간의 가로 간격
                        childAspectRatio: 2, // 아이템의 가로 세로 비율
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final document = data[index];
                          return ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/detail',
                                    arguments: {
                                      document,
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero, // 둥근 모서리를 없앰
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    const SizedBox(width: 25),
                                    Container(
                                      height: 200,
                                      width: 100,
                                      color: Colors.red,
                                      child: Center(
                                        child: Text(
                                          document['question_sector'],
                                          style: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 200,
                                      width: 250,
                                      color: Colors.blue,
                                      child: Center(
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                softWrap: true,
                                                maxLines: 10,
                                                overflow: TextOverflow.visible,
                                                document['question_text'],
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        },
                        childCount: data.length,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      // 홈 버튼을 눌렀을 때 홈 화면으로 이동
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GameScreen'),
      ),
      body: Center(
        child: Text('Selected Index: $_selectedIndex'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      // 홈 버튼을 눌렀을 때 홈 화면으로 이동
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatbotScreen'),
      ),
      body: Center(
        child: Text('Selected Index: $_selectedIndex'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final Set<QueryDocumentSnapshot> document = ModalRoute.of(context)!
        .settings
        .arguments as Set<QueryDocumentSnapshot>;
    return Scaffold(
        appBar: AppBar(
          title: const Text("DetailScreen"),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(width: 25),
            Text('학년: ${document.first['question_step']}',
                style: const TextStyle(fontSize: 20, color: Colors.black)),
            const SizedBox(width: 50),
            Text('단원: ${document.first['question_difficulty'].toString()}',
                style: const TextStyle(fontSize: 20, color: Colors.black)),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 25),
              Text('개념: ${document.first['question_topic_name']}',
                  style: const TextStyle(fontSize: 20, color: Colors.black)),
            ],
          ),
          Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 25, height: 100),
                      Expanded(
                        child: Text(document.first['question_text']),
                      ),
                      const SizedBox(width: 25, height: 100),
                    ],
                  )
                ],
              ),
            ),
          )
        ]));
  }
}
