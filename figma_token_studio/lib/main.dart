import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: CustomCalendar(),
        )
        //     child: TableCalendar(
        //   firstDay: DateTime.utc(2010, 10, 16),
        //   lastDay: DateTime.utc(2030, 3, 14),
        //   focusedDay: DateTime.now(),
        // )),
        );
  }
}

class CustomCalendar extends StatefulWidget {
  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 🟢 특정 날짜에 표시할 이미지 맵 (예: 3월 11일, 3월 15일 등)
  final Map<DateTime, String> _eventImages = {
    DateTime(2024, 3, 11): 'assets/images/img_mine_dolo.png',
    DateTime(2024, 3, 15): 'assets/images/img_mine_info_diamond.png',
    DateTime(2024, 3, 20): 'assets/images/img_mine_info_mano.png',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('이미지 캘린더')),
      body: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        // ✅ 특정 날짜 셀 커스터마이징 (이미지 추가)
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            // 🟢 특정 날짜에 이미지가 있으면 이미지 포함
            if (_eventImages.containsKey(day)) {
              return Container(
                width: 40, // 네모 크기 조절 가능
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), // 네모난 스타일
                  border: Border.all(color: Colors.grey),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      _eventImages[day]!,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover, // 네모 안에 꽉 채우기
                    ),
                    Positioned(
                      bottom: 2,
                      child: Text(
                        '${day.day}', // 날짜 텍스트 유지
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.black54, // 날짜 가독성 향상
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            // 기본 날짜 스타일
            return Center(
              child: Text(
                '${day.day}',
                style: TextStyle(fontSize: 16),
              ),
            );
          },
        ),
      ),
    );
  }
}
