import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalendarPage extends StatelessWidget {
  const TableCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            headerVisible: false,
            // another setup here
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, day, focusedDay) =>
                  _buildCellDate(day, focusedDay: focusedDay),
              defaultBuilder: (context, day, focusedDay) => _buildCellDate(day),
              todayBuilder: (context, day, focusedDay) => _buildCellDate(day),
            )));
  }

  Widget _buildCellDate(DateTime day, {DateTime? focusedDay}) {
    return Container(
      margin: const EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: (day == focusedDay) ? BoxShape.circle : BoxShape.rectangle,
        color: Colors.redAccent, // you custom color here
        borderRadius: (day == focusedDay) ? null : BorderRadius.circular(4),
      ),
      child: Text(
        day.day.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
