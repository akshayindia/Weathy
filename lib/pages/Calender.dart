// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:table_calendar_example/Provider/AirTableApi.dart';

import '../utils.dart';


class TableEventsExample extends StatefulWidget {
  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late  ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
Map<DateTime, List<Event>> _listEvent = {};
bool _isLoading = false;
  // GlobalKey<FormState> _form106 = GlobalKey<FormState>();



  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
  }

  @override
  void didChangeDependencies() {
_listEvent = Provider.of<AirTableApi>(context).iteams;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
  // Implementation example
print (_listEvent[day]);
    // AirTableApi().listEvent[day]
    return  _listEvent[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar - Events'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          _isLoading?CircularProgressIndicator():
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0 && value.length == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: (){

                       setState((){
                            _isLoading = true;
                          });
                          
                          Provider.of<AirTableApi>(context, listen:  false).createrecord(_selectedDay).whenComplete(() => 
                          setState((){
                            _isLoading = false;
                          })
                          );

                        }, child: Text('Add Price')),
                      );
                    } 
                    else if (index ==1 ) {
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.currency_rupee),
                        trailing: IconButton(icon: Icon(Icons.delete_outline), onPressed: (){
                          setState(() {
                            _isLoading = true;
                          });
                          Provider.of<AirTableApi>(context, listen:  false).deleteRecord(_selectedDay).whenComplete(() => 
                            setState((){
                            _isLoading = false;
                          })
                          );
                          

                        },),
                        // onTap: () => print('${value[index]}'),
                        title: Text('Rs ' +'${value[index-1]}'),
                      ),
                    );}
                    else {
                      return SizedBox();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
