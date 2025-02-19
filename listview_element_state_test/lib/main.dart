import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List & Detail with Animation',
      home: ParentWidget(),
    );
  }
}

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  // ListView의 스크롤 상태를 유지하기 위한 ScrollController
  final ScrollController _scrollController = ScrollController();

  // 각 리스트 아이템을 제어하기 위한 GlobalKey 리스트 (20개의 아이템)
  final List<GlobalKey<ListItemState>> _itemKeys =
      List.generate(20, (index) => GlobalKey<ListItemState>());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List & Detail with Animation')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _itemKeys.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              // 현재 아이템의 카운터 값을 GlobalKey를 통해 가져옵니다.
              int currentValue = _itemKeys[index].currentState?.counter ?? 0;
              // 상세 화면으로 이동하며 현재 카운터 값을 전달합니다.
              final updatedValue = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    index: index,
                    counter: currentValue,
                  ),
                ),
              );
              // 상세 화면에서 돌아올 때 수정된 값이 있으면 해당 아이템에 업데이트합니다.
              if (updatedValue != null && updatedValue is int) {
                _itemKeys[index].currentState?.updateCounter(updatedValue);
              }
            },
            child: ListItem(
              key: _itemKeys[index],
              index: index,
            ),
          );
        },
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  final int index;
  const ListItem({Key? key, required this.index}) : super(key: key);

  @override
  ListItemState createState() => ListItemState();
}

class ListItemState extends State<ListItem> {
  int counter = 0;

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  // 외부에서 상세 화면의 결과로 전달받은 새로운 값으로 업데이트하기 위한 메서드
  void updateCounter(int newVal) {
    setState(() {
      counter = newVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Item ${widget.index}'),
      // AnimatedSwitcher로 counter 텍스트에 애니메이션 효과 적용
      subtitle: AnimatedSwitcher(
        duration: Duration(milliseconds: 1000),
        // 새 텍스트는 500ms 이후부터 애니메이션 시작 (즉, 500ms 동안은 공백처럼 유지)
        switchInCurve: Interval(0.5, 1.0, curve: Curves.easeInOut),
        // 기존 텍스트는 첫 250ms 정도 빠르게 fade-out되어 깜빡이는 효과를 줌
        switchOutCurve: Interval(0.0, 0.25, curve: Curves.easeOut),
        transitionBuilder: (child, animation) {
          // child의 key가 현재 counter 값과 같으면 새 위젯으로 판단
          if (child.key == ValueKey(counter)) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(-1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          } else {
            // 이전 위젯은 단순 fade-out 효과
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          }
        },
        child: Text(
          'Counter: $counter',
          key: ValueKey<int>(counter),
          style: TextStyle(fontSize: 16),
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: incrementCounter,
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final int index;
  final int counter;
  const DetailPage({Key? key, required this.index, required this.counter})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late int counter;

  @override
  void initState() {
    super.initState();
    counter = widget.counter;
  }

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail of Item ${widget.index}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Counter: $counter', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: incrementCounter,
              child: Text('Increment'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 뒤로 가기 전, 수정된 카운터 값을 전달합니다.
                Navigator.pop(context, counter);
              },
              child: Text('Go Back'),
            )
          ],
        ),
      ),
    );
  }
}
