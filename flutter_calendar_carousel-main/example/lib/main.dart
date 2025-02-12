import 'package:example/table_calendar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calendar Comparison',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Flutter Calendar Carousel Comparison'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  DateTime _targetDateTime = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());

  EventList<Event> _markedDateMap = EventList<Event>(events: {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _buildCalendarPage('캘린더 1'),
          TableCalendarPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.swap_horiz),
        onPressed: () {
          int nextPage = (_currentPage + 1) % 2;
          _pageController.animateToPage(
            nextPage,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  Widget _buildCalendarPage(String title) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: CalendarCarousel<Event>(
              todayBorderColor: Colors.green,
              thisMonthDayBorderColor: Colors.grey,
              weekendTextStyle: TextStyle(color: Colors.red),
              height: 420.0,
              selectedDateTime: _targetDateTime,
              targetDateTime: _targetDateTime,
              markedDatesMap: _markedDateMap,
              onCalendarChanged: (DateTime date) {
                setState(() {
                  _targetDateTime = date;
                  _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
