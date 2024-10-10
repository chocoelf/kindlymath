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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen()
        // '/three': (context) => ThreeScreen(),
        // '/four': (context) => FourScreen()
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/job') {
          return MaterialPageRoute(
              builder: (context) => const JobScreen(), settings: settings);
        } else if (settings.name == '/math') {
          return MaterialPageRoute(
              builder: (context) => const MathScreen(), settings: settings);
        } else if (settings.name == '/work') {
          return MaterialPageRoute(
              builder: (context) => const WorkScreen(), settings: settings);
        } else if (settings.name == '/detail1') {
          return MaterialPageRoute(
              builder: (context) => const Detail1Screen(), settings: settings);
        } else if (settings.name == '/detail2') {
          return MaterialPageRoute(
              builder: (context) => const Detail2Screen(), settings: settings);
        } else if (settings.name == '/detail3') {
          return MaterialPageRoute(
              builder: (context) => const Detail3Screen(), settings: settings);
        }
        return null;
      },
    );
  }
}

class BaseScreen extends StatelessWidget {
  const BaseScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          final TabController tabController = DefaultTabController.of(context);
          final currentTabIndex = tabController.index; // 현재 탭 인덱스 가져오기
          final currentRoute = ModalRoute.of(context)?.settings.name;
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/game');
              break;
            case 2:
              if (currentRoute != '/home') {
                Navigator.pushNamed(context, '/home');
              } else {
                if (currentTabIndex == 1) {
                  Navigator.pushNamed(context, '/home');
                } else if (currentTabIndex == 2) {
                  Navigator.pushNamed(context, '/home');
                }
              }
              break;
            case 3:
              Navigator.pushNamed(context, '/chatbot');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ]);
  }
}

class CustomTabBarView extends StatelessWidget {
  const CustomTabBarView(
      {super.key,
      required this.data1,
      required this.data2,
      required this.data3,
      required this.tabIndex});
  final List<String> data1;
  final List<String> data2;
  final List<String> data3;
  final int tabIndex;
  @override
  Widget build(BuildContext context) {
    return TabBarView(children: [
      MathConcept(data1: data1, data2: data2, data3: data3, tabIndex: tabIndex),
      JobExplore(data1: data1, data2: data2, data3: data3, tabIndex: tabIndex),
      Work(data1: data1, data2: data2, data3: data3, tabIndex: tabIndex),
    ]);
  }
}

class ScrollView extends StatelessWidget {
  const ScrollView(
      {super.key,
      required this.data,
      required this.textData,
      required this.tabIndex,
      required this.scrollIndex});

  final List<String> data;
  final String textData;

  final int tabIndex;
  final int scrollIndex;

  // Firestore에서 데이터 가져오기
  Future<List<QueryDocumentSnapshot>> fetchDatalike(
      String collectionName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName) // 불러올 Firestore 컬렉션 이름
        .orderBy('likedCount', descending: true) // 원하는 필드를 기준으로 정렬
        .get();

    return querySnapshot.docs; // QueryDocumentSnapshot의 리스트 반환
  }

  Future<List<QueryDocumentSnapshot>> fetchDataview(
      String collectionName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName) // 불러올 Firestore 컬렉션 이름
        .orderBy('viewCount', descending: true) // 원하는 필드를 기준으로 정렬
        .get();

    return querySnapshot.docs; // 정렬된 데이터를 반환
  }

  Future<List<QueryDocumentSnapshot>> fetchDatarecommend(
      String collectionName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName) // 불러올 Firestore 컬렉션 이름
        .orderBy('viewCount', descending: true) // 원하는 필드를 기준으로 정렬
        .get();

    return querySnapshot.docs; // 정렬된 데이터를 반환
  }

  @override
  Widget build(BuildContext context) {
    String collectionName = '';
    String textCategory = '';
    String scrollcount = '';
    String? scrollcount2 = '';
    late Future<List<QueryDocumentSnapshot>> fetchFunction;

    if (tabIndex == 0) {
      collectionName = 'MathJobs';
      textCategory = 'job';
      if (scrollIndex == 0) {
        fetchFunction = fetchDatalike(collectionName);
        scrollcount = 'likedCount';
        scrollcount2 = null;
      } else if (scrollIndex == 1) {
        fetchFunction = fetchDataview(collectionName);
        scrollcount = 'viewCount';
        scrollcount2 = null;
      } else if (scrollIndex == 2) {
        fetchFunction = fetchDatarecommend(collectionName);
        scrollcount = 'viewCount';
        scrollcount2 = null;
      }
    } else if (tabIndex == 1) {
      collectionName = 'concept';
      textCategory = 'category';
      if (scrollIndex == 0) {
        fetchFunction = fetchDatalike(collectionName);
        scrollcount = 'likedCount';
        scrollcount2 = 'appliedConcept';
      } else if (scrollIndex == 1) {
        fetchFunction = fetchDataview(collectionName);
        scrollcount = 'viewCount';
        scrollcount2 = 'appliedConcept';
      } else if (scrollIndex == 2) {
        fetchFunction = fetchDatarecommend(collectionName);
        scrollcount = 'viewCount';
        scrollcount2 = 'appliedConcept';
      }
    } else if (tabIndex == 2) {
      collectionName = 'work';
      textCategory = 'workTitle';
      if (scrollIndex == 0) {
        fetchFunction = fetchDatalike(collectionName);
        scrollcount = 'likedCount';
        scrollcount2 = null;
      } else if (scrollIndex == 1) {
        fetchFunction = fetchDataview(collectionName);
        scrollcount = 'viewCount';
        scrollcount2 = null;
      } else if (scrollIndex == 2) {
        fetchFunction = fetchDatarecommend(collectionName);
        scrollcount = 'viewCount';
        scrollcount2 = null;
      }
    }
    return Column(
      children: [
        const SizedBox(height: 30),
        Align(
          alignment: Alignment.topLeft,
          child: Text(textData),
        ),
        const SizedBox(height: 30),
        // 데이터를 비동기로 가져오는 FutureBuilder 사용
        FutureBuilder<List<QueryDocumentSnapshot>>(
          future: fetchFunction, // Firestore에서 데이터 가져오기
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 데이터를 불러오는 중일 때 로딩 표시
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // 에러 발생 시 에러 메시지 출력
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              // 데이터를 성공적으로 불러왔을 때 GridView 표시
              final data = snapshot.data!;
              return Container(
                height: 150,
                color: Colors.white,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal, // 가로로 스크롤
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // 한 줄에 한 개의 항목을 표시
                    childAspectRatio: 1, // 항목의 가로 세로 비율
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final document = data[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (tabIndex == 0) {
                            Navigator.pushNamed(context, '/detail1',
                                arguments: {
                                  document,
                                });
                          } else if (tabIndex == 1) {
                            Navigator.pushNamed(context, '/detail2',
                                arguments: {
                                  document,
                                });
                          } else if (tabIndex == 2) {
                            Navigator.pushNamed(context, '/detail3',
                                arguments: {
                                  document,
                                });
                          } else {
                            // 필터링된 문서가 없을 때의 동작
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('No matching documents found')),
                            );
                          }
                        },
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Text(document[textCategory]),
                          Text(document[scrollcount].toString()),
                          if (scrollcount2 != null)
                            Text(document[scrollcount2].toString()),
                        ]),
                      ),
                    );
                  },
                ),
              );
            } else {
              // 데이터가 없는 경우 처리
              return const Text('No data available');
            }
          },
        ),
      ],
    );
  }
}

class Concept extends StatelessWidget {
  const Concept(
      {super.key,
      required this.data1,
      required this.data2,
      required this.data3,
      required this.tabIndex});

  final List<String> data1;
  final List<String> data2;
  final List<String> data3;
  final int tabIndex;
  final String text1 = "     '좋아요'가 가장 만은 Connection";
  final String text2 = "     '조회수'가 가장 만은 Connection";
  final String text3 = "     흥미 UP! MD 추천 Connection";

  final int scrollIndex1 = 0;
  final int scrollIndex2 = 1;
  final int scrollIndex3 = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScrollView(
            data: data1,
            textData: text1,
            tabIndex: tabIndex,
            scrollIndex: scrollIndex1),
        ScrollView(
            data: data2,
            textData: text2,
            tabIndex: tabIndex,
            scrollIndex: scrollIndex2),
        ScrollView(
            data: data3,
            textData: text3,
            tabIndex: tabIndex,
            scrollIndex: scrollIndex3),
      ],
    );
  }
}

class MathConcept extends StatelessWidget {
  const MathConcept({
    super.key,
    required this.data1,
    required this.data2,
    required this.data3,
    required this.tabIndex,
  });

  final List<String> data1;
  final List<String> data2;
  final List<String> data3;

  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    return Concept(
        data1: data1, data2: data2, data3: data3, tabIndex: tabIndex);
  }
}

class JobExplore extends StatelessWidget {
  const JobExplore({
    super.key,
    required this.data1,
    required this.data2,
    required this.data3,
    required this.tabIndex,
  });
  final List<String> data1;
  final List<String> data2;
  final List<String> data3;

  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    return Concept(
        data1: data1, data2: data2, data3: data3, tabIndex: tabIndex);
  }
}

class Work extends StatelessWidget {
  const Work({
    super.key,
    required this.data1,
    required this.data2,
    required this.data3,
    required this.tabIndex,
  });
  final List<String> data1;
  final List<String> data2;
  final List<String> data3;

  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    return Concept(
        data1: data1, data2: data2, data3: data3, tabIndex: tabIndex);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TabController _tabController;

  List<String> _uniqueValues1 = [];
  List<String> _uniqueValues2 = [];
  List<String> _uniqueValues3 = [];

  @override
  void initState() {
    super.initState();
    _fetchUniqueValues();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 상태 업데이트
    });
  }

  Future<void> _fetchUniqueValues() async {
    final querySnapshot1 = await _firestore.collection('MathJobs').get();

    // question_topic_name 필드의 고유 값 가져오기
    final allValues1 =
        querySnapshot1.docs.map((doc) => doc['job'] as String).toList();
    final uniqueValues1 = allValues1.toSet().toList(); // 중복 제거

    final querySnapshot2 = await _firestore.collection('concept').get();

    // question_step 필드의 고유 값 가져오기
    final allValues2 =
        querySnapshot2.docs.map((doc) => doc['category'] as String).toList();
    final uniqueValues2 = allValues2.toSet().toList(); // 중복 제거

    final querySnapshot3 = await _firestore.collection('work').get();

    // question_difficulty 필드의 고유 값 가져오기
    final allValues3 =
        querySnapshot3.docs.map((doc) => doc['job'] as String).toList();

    final uniqueValues3 = allValues3.toSet().toList(); // 중복 제거

    setState(() {
      _uniqueValues1 = uniqueValues1;
      _uniqueValues2 = uniqueValues2;
      _uniqueValues3 = uniqueValues3;
    });
  }

  Set<List<QueryDocumentSnapshot>> documents = {};

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('HomeScreen'),
          ),
          body: Center(
              child: Column(children: [
            Container(
              color: Colors.blue,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black, // 선택된 탭의 색상
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: '직업탐구'),
                  Tab(text: '수학개념'),
                  Tab(text: '업무'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (currentRoute == '/home') {
                        if (_tabController.index == 0) {
                          Navigator.pushNamed(context, '/job');
                        } else if (_tabController.index == 1) {
                          Navigator.pushNamed(context, '/math');
                        } else if (_tabController.index == 2) {
                          Navigator.pushNamed(context, '/work');
                        }
                      }
                    },
                    child: const Text('리스트 보기')),
              ],
            ),
            Expanded(
                child: CustomTabBarView(
                    data1: _uniqueValues1,
                    data2: _uniqueValues2,
                    data3: _uniqueValues3,
                    tabIndex: _tabController.index))
          ])),
          bottomNavigationBar: const BaseScreen(),
        ));
  }
}

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen(
      {super.key,
      required this.collectionName,
      required this.title,
      required this.explain,
      required this.tapIndex});

  final String collectionName;
  final String title;
  final String explain;
  final String tapIndex;

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(widget.collectionName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final documents = snapshot.data!.docs;
          return Column(children: [
            Expanded(
                child: documents.isEmpty
                    ? const Center(child: Text('No data available'))
                    : CustomScrollView(
                        slivers: [
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1, // 열의 수를 설정
                              mainAxisSpacing: 10, // 아이템 간의 세로 간격
                              crossAxisSpacing: 10, // 아이템 간의 가로 간격
                              childAspectRatio: 2,
                              mainAxisExtent: 100, // 아이템의 가로 세로 비율
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final document = documents[index];
                                return ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/detail${widget.tapIndex}',
                                          arguments: {
                                            document,
                                          });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.zero, // 둥근 모서리를 없앰
                                      ),
                                    ),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 200,
                                            color: Colors.white,
                                            child: Center(
                                              child: Text(
                                                document[widget.title],
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 100,
                                            width: 200,
                                            color: Colors.white,
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      softWrap: true,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      document[widget.explain],
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                              },
                              childCount: documents.length,
                            ),
                          ),
                        ],
                      ))
          ]);
        });
  }
}

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  _JobScreenState createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3, // 탭의 개수 설정
        child: Scaffold(
            appBar: AppBar(
              title: const Text('직업 Connection'),
            ),
            body: const ConnectionScreen(
                collectionName: 'MathJobs',
                title: 'job',
                explain: 'explain',
                tapIndex: '1'),
            bottomNavigationBar: const BaseScreen()));
  }
}

class MathScreen extends StatefulWidget {
  const MathScreen({
    super.key,
  });
  @override
  _MathScreenState createState() => _MathScreenState();
}

class _MathScreenState extends State<MathScreen> {
  final Set<List<QueryDocumentSnapshot>> documents = {};
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3, // 탭의 개수 설정
        child: Scaffold(
          appBar: AppBar(
            title: const Text('개념 Connection'),
          ),
          body: const ConnectionScreen(
              collectionName: 'concept',
              title: 'category',
              explain: 'conceptDescription',
              tapIndex: '2'),
          bottomNavigationBar: const BaseScreen(),
        ));
  }
}

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});
  @override
  _WorkScreenState createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  final Set<List<QueryDocumentSnapshot>> documents = {};
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3, // 탭의 개수 설정
        child: Scaffold(
          appBar: AppBar(
            title: const Text('업무 Connection'),
          ),
          body: const ConnectionScreen(
              collectionName: 'work',
              title: 'job',
              explain: 'workTitle',
              tapIndex: '3'),
          bottomNavigationBar: const BaseScreen(),
        ));
  }
}

class Detail1Screen extends StatefulWidget {
  const Detail1Screen({
    super.key,
  });

  @override
  _Detail1ScreenState createState() => _Detail1ScreenState();
}

class _Detail1ScreenState extends State<Detail1Screen> {
  @override
  Widget build(BuildContext context) {
    final Set<QueryDocumentSnapshot> document = ModalRoute.of(context)!
        .settings
        .arguments as Set<QueryDocumentSnapshot>;

    return DefaultTabController(
      length: 4, // 탭의 개수 설정
      child: Scaffold(
        appBar: AppBar(
          title: const Text('직업 Connection'),
        ),
        body: document.isEmpty
            ? const Center(child: Text('No data available'))
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 상단 정보
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 25),
                      Text('직업: ${document.first['job']}',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black)),
                      const SizedBox(width: 50)
                    ],
                  ),
                  // TabBar와 TabBarView 추가
                  Expanded(
                      child:
                          // 설명 탭 (explain 필드)
                          SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          const Text('설명',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Text(document.first['explain']),
                          const SizedBox(height: 20),
                          const Text('예시',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Text(document.first['example']),
                          const SizedBox(height: 20),
                          const Text('질문',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Text(document.first['question']),
                          const SizedBox(height: 20),
                          const Text('스토리',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Text(document.first['story']),
                        ])),
                  )),
                ],
              ),
        bottomNavigationBar: const BaseScreen(),
      ),
    );
  }
}

class Detail2Screen extends StatefulWidget {
  const Detail2Screen({
    super.key,
  });

  @override
  _Detail2ScreenState createState() => _Detail2ScreenState();
}

class _Detail2ScreenState extends State<Detail2Screen> {
  @override
  Widget build(BuildContext context) {
    final Set<QueryDocumentSnapshot> document = ModalRoute.of(context)!
        .settings
        .arguments as Set<QueryDocumentSnapshot>;

    return DefaultTabController(
      length: 4, // 탭의 개수 설정
      child: Scaffold(
        appBar: AppBar(
          title: const Text('개념 Connection'),
        ),
        body: document.isEmpty
            ? const Center(child: Text('No data available'))
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 상단 정보
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 25),
                      Text('개념: ${document.first['category']}',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black)),
                      const SizedBox(width: 50)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 25),
                      Text('세부 개념: ${document.first['appliedConcept']}',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black)),
                      const SizedBox(width: 50)
                    ],
                  ),
                  // TabBar와 TabBarView 추가
                  Expanded(
                      child:
                          // 설명 탭 (explain 필드)
                          SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          const Text('예제',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Text(document.first['appliedQuestion']),
                          const SizedBox(height: 20),
                          const Text('개념 설명',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Text(document.first['conceptDescription']),
                        ])),
                  )),
                ],
              ),
        bottomNavigationBar: const BaseScreen(),
      ),
    );
  }
}

class Detail3Screen extends StatefulWidget {
  const Detail3Screen({
    super.key,
  });

  @override
  _Detail3ScreenState createState() => _Detail3ScreenState();
}

class _Detail3ScreenState extends State<Detail3Screen> {
  @override
  Widget build(BuildContext context) {
    final Set<QueryDocumentSnapshot> document = ModalRoute.of(context)!
        .settings
        .arguments as Set<QueryDocumentSnapshot>;

    return DefaultTabController(
      // DefaultTabController를 Scaffold 상위에 추가
      length: 2, // 탭의 개수 설정
      child: Scaffold(
        appBar: AppBar(
          title: const Text('업무 Connection'),
        ),
        body: document.isEmpty
            ? const Center(child: Text('No data available'))
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 상단 정보
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 25),
                      Text('직업: ${document.first['job']}',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black)),
                      const SizedBox(width: 50)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 25),
                      Text('업무: ${document.first['workTitle']}',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black)),
                      const SizedBox(width: 50)
                    ],
                  ),
                  // TabBar와 TabBarView 추가
                  Expanded(
                      child:
                          // 설명 탭 (explain 필드)
                          SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          const Text('예제',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Text(document.first['addQuestion']),
                          const SizedBox(height: 20),
                          const Text('업무',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Text(document.first['workTodo']),
                        ])),
                  )),
                ],
              ),
        bottomNavigationBar: const BaseScreen(),
      ),
    );
  }
}
