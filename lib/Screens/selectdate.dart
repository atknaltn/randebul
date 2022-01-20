import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'confirm_andpay.dart';

class SelectDatePage extends StatefulWidget {
  final dynamic hocaRef;
  final DocumentSnapshot hocaSnapshot;
  final Map selectedHizmet;
  final int sourcePlace;
  const SelectDatePage({
    Key? key,
    required this.hocaRef,
    required this.selectedHizmet,
    required this.hocaSnapshot,
    required this.sourcePlace,
  }) : super(key: key);

  @override
  _SelectDatePageState createState() => _SelectDatePageState();
}

class _SelectDatePageState extends State<SelectDatePage> {
  DateTime selectedDate = DateTime.now().add(const Duration(minutes: 10));
  bool validTime = true;
  dynamic randevuList = <Map>[];

  String? _subjectText = '',
      _startTimeText = '',
      _endTimeText = '',
      _dateText = '',
      _timeDetails = '';

  @override
  Widget build(BuildContext context) {
    checkTimeValidity();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Select Date and Time'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          (validTime)
              ? const Center(
                  child: Text(
                    'Please Select Date and Time:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )
              : const Center(
                  child: Text(
                    'Please Select a VALID Time:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _openDatePicker(context),
            child: const Text('Select Date'),
          ),
          ElevatedButton(
            onPressed: () => _openTimePicker(context),
            child: const Text('Select Time'),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Selected: ${DateFormat('dd.MM.y - HH:mm').format(selectedDate)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 550,
            child: SfCalendar(
              appointmentTimeTextFormat: 'hh:mm',
              view: CalendarView.week,
              firstDayOfWeek: DateTime.now().weekday,
              timeSlotViewSettings: const TimeSlotViewSettings(
                timeInterval: Duration(minutes: 30),
                timeFormat: 'HH:mm',
                dayFormat: 'EEE',
                startHour: 9,
                endHour: 17,
              ),
              dataSource: MeetingDataSource(getAppointments()),
              onTap: calendarTapped,
            ),
          ),
        ],
      ),
      floatingActionButton: (validTime)
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfirmAndPay(
                            selectedHizmet: widget.selectedHizmet,
                            hocaRef: widget.hocaRef,
                            selectedDate: selectedDate,
                            hocaSnapshot: widget.hocaSnapshot,
                            sourcePlace: widget.sourcePlace)));
              },
              label: const Text('Confirm'),
              icon: const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              backgroundColor: Colors.green,
            )
          : null,
    );
  }

  void checkTimeValidity() {
    selectedDate = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedDate.hour, roundTo5(selectedDate.minute));
    randevuList = widget.hocaRef['Randevular'];
    if (widget.hocaRef['Randevular'] != null) {
      for (int i = 0; i < randevuList.length; i++) {
        if ((selectedDate.isAfter(randevuList[i]['startTime'].toDate()) &&
                selectedDate.isBefore(randevuList[i]['startTime']
                    .toDate()
                    .add(Duration(minutes: randevuList[i]['duration'])))) ||
            (selectedDate
                    .add(Duration(minutes: widget.selectedHizmet['serviceDuration']))
                    .isAfter(randevuList[i]['startTime'].toDate()) &&
                selectedDate
                    .add(Duration(minutes: widget.selectedHizmet['serviceDuration']))
                    .isBefore(randevuList[i]['startTime']
                        .toDate()
                        .add(Duration(minutes: randevuList[i]['duration'])))) ||
            selectedDate
                .isAtSameMomentAs(randevuList[i]['startTime'].toDate())) {
          setState(() {
            validTime = false;
          });
          break;
        }
      }
    }

    if (selectedDate.hour > 17 || selectedDate.hour < 9) {
      validTime = false;
    }
  }

  _openDatePicker(BuildContext context) async {
    dynamic randevuList = <Map>[];
    bool conflict = false;
    randevuList = widget.hocaRef['Randevular'];

    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );

    if (date != null) {
      DateTime fullDate = DateTime(date.year, date.month, date.day,
          selectedDate.hour, selectedDate.minute);

      if (fullDate.isBefore(DateTime.now())) {
        setState(() {
          validTime = false;
        });
        conflict = true;
      }

      if (widget.hocaRef['Randevular'] != null) {
        for (int i = 0; i < randevuList.length; i++) {
          if ((fullDate.isAfter(randevuList[i]['startTime'].toDate()) &&
                  fullDate.isBefore(randevuList[i]['startTime']
                      .toDate()
                      .add(Duration(minutes: randevuList[i]['duration'])))) ||
              (fullDate
                      .add(Duration(minutes: widget.selectedHizmet['serviceDuration']))
                      .isAfter(randevuList[i]['startTime'].toDate()) &&
                  fullDate
                      .add(Duration(minutes: widget.selectedHizmet['serviceDuration']))
                      .isBefore(randevuList[i]['startTime'].toDate().add(
                          Duration(minutes: randevuList[i]['duration']))))) {
            conflict = true;
            setState(() {
              validTime = false;
            });
            break;
          }
        }
      }

      if (!conflict) {
        setState(() {
          validTime = true;
          selectedDate = fullDate;
        });
      }
    }
  }

  _openTimePicker(BuildContext context) async {
    dynamic randevuList = <Map>[];
    randevuList = widget.hocaRef['Randevular'];
    bool conflict = false;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute),
    );

    if (time != null) {
      DateTime fullDate = DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, time.hour, roundTo5(time.minute));

      if (fullDate.isBefore(DateTime.now())) {
        setState(() {
          validTime = false;
          conflict = true;
        });
      }

      if (widget.hocaRef['Randevular'] != null) {
        for (int i = 0; i < randevuList.length; i++) {
          if ((fullDate.isAfter(randevuList[i]['startTime'].toDate()) &&
                  fullDate.isBefore(randevuList[i]['startTime']
                      .toDate()
                      .add(Duration(minutes: randevuList[i]['duration'])))) ||
              (fullDate
                      .add(Duration(minutes: widget.selectedHizmet['serviceDuration']))
                      .isAfter(randevuList[i]['startTime'].toDate()) &&
                  fullDate
                      .add(Duration(minutes: widget.selectedHizmet['serviceDuration']))
                      .isBefore(randevuList[i]['startTime'].toDate().add(
                          Duration(minutes: randevuList[i]['duration']))))) {
            conflict = true;
            setState(() {
              validTime = false;
            });
            break;
          }
        }
      }

      if (fullDate.hour > 17 || fullDate.hour < 9) {
        conflict = true;
        setState(() {
          validTime = false;
        });
      }

      if (!conflict) {
        setState(() {
          selectedDate = fullDate;
          validTime = true;
        });
      }
    }
  }

  int roundTo5(int num) {
    int remainder = num % 5;
    if (remainder < 3) {
      return num - remainder;
    } else {
      return num + (5 - remainder);
    }
  }

  List<Appointment> getAppointments() {
    List<Appointment> meetings = <Appointment>[];
    dynamic randevuList = <Map>[];
    randevuList = widget.hocaRef['Randevular'];

    if (widget.hocaRef['Randevular'] != null) {
      for (int i = 0; i < randevuList.length; i++) {
        meetings.add(Appointment(
            startTime: randevuList[i]['startTime'].toDate(),
            endTime: randevuList[i]['startTime']
                .toDate()
                .add(Duration(minutes: randevuList[i]['duration'])),
            subject: 'Taken',
            color: Colors.red,
            isAllDay: false));
      }
    }
    meetings.add(Appointment(
        startTime: selectedDate,
        endTime:
            selectedDate.add(Duration(minutes: widget.selectedHizmet['serviceDuration'])),
        subject: 'Seçilen Tarih',
        color: Colors.blue,
        isAllDay: false));

    return meetings;
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Appointment appointmentDetails = details.appointments![0];
      _subjectText = appointmentDetails.subject;
      _dateText = DateFormat('MMMM dd, yyyy')
          .format(appointmentDetails.startTime)
          .toString();
      _startTimeText =
          DateFormat('HH:mm').format(appointmentDetails.startTime).toString();
      _endTimeText =
          DateFormat('HH:mm').format(appointmentDetails.endTime).toString();
      if (appointmentDetails.isAllDay) {
        _timeDetails = 'All day';
      } else {
        _timeDetails = '$_startTimeText - $_endTimeText';
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('$_subjectText'),
              content: SizedBox(
                height: 80,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '$_dateText',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const <Widget>[
                        Text(''),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(_timeDetails!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15)),
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('close'))
              ],
            );
          });
    }
  }
}


class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
