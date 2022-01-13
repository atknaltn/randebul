import 'package:flutter/material.dart';
import 'package:randebul/Screens/appointment_screen.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ConfirmAppointmentPage extends StatefulWidget {
  final dynamic hocaRef;
  final Map selectedHizmet;
  const ConfirmAppointmentPage({
    Key? key,
    required this.hocaRef,
    required this.selectedHizmet,
  }) : super(key: key);

  @override
  _ConfirmAppointmentPageState createState() => _ConfirmAppointmentPageState();
}

class _ConfirmAppointmentPageState extends State<ConfirmAppointmentPage> {
  DateTime selectedDate = DateTime.now();
  bool validTime = true;
  dynamic randevuList = <Map>[];

  String? _subjectText = '',
      _startTimeText = '',
      _endTimeText = '',
      _dateText = '',
      _timeDetails = '';

  @override
  Widget build(BuildContext context) {
    randevuList = widget.hocaRef['Randevular'];
    for (int i = 0; i < randevuList.length; i++) {
      if ((selectedDate.isAfter(randevuList[i]['startTime'].toDate()) &&
              selectedDate.isBefore(randevuList[i]['startTime']
                  .toDate()
                  .add(Duration(minutes: randevuList[i]['duration'])))) ||
          (selectedDate
                  .add(Duration(minutes: widget.selectedHizmet['sure']))
                  .isAfter(randevuList[i]['startTime'].toDate()) &&
              selectedDate
                  .add(Duration(minutes: widget.selectedHizmet['sure']))
                  .isBefore(randevuList[i]['startTime']
                      .toDate()
                      .add(Duration(minutes: randevuList[i]['duration']))))) {
        setState(() {
          validTime = false;
        });
        break;
      }
    }

    if(selectedDate.hour > 17 || selectedDate.hour < 9){
      validTime = false;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Randevuyu Onayla'),
      ),
      body: ListView(
        children: [
          const Center(
            child: Text(
              'Seçilen Randevu',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          ServiceBox(
            serviceName: '${widget.selectedHizmet['başlık']}',
            duration: '${widget.selectedHizmet['sure']}',
            icerik: '${widget.selectedHizmet['icerik']}',
            fiyat: '${widget.selectedHizmet['fiyat']}',
            isSelected: true,
            index: 0,
          ),
          Center(
            child: Text(
              'Seçilen Profesyonel: ${widget.hocaRef['name']} ${widget.hocaRef['surname']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
          (validTime)
              ? const Center(
                  child: Text(
                    'Tarih ve Saat Seçiniz:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )
              : const Center(
                  child: Text(
                    'Lütfen Geçerli Bir Tarih ve Saat Seçiniz:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
          ElevatedButton(
            onPressed: () => _openDatePicker(context),
            child: const Text('Tarih Seçin.'),
          ),
          ElevatedButton(
            onPressed: () => _openTimePicker(context),
            child: const Text('Saat Seçin.'),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Seçili Tarih: ${DateFormat('dd.MM.y - HH:mm').format(selectedDate)}',
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
      floatingActionButton: (validTime) ? FloatingActionButton.extended(
        onPressed: (){print('zort');},
        label: const Text('Onayla'),
        icon: const Icon(Icons.check_circle,
              color: Colors.white,),
        backgroundColor: Colors.green,

      )
      : null,
    );
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

      for (int i = 0; i < randevuList.length; i++) {
        if ((fullDate.isAfter(randevuList[i]['startTime'].toDate()) &&
                fullDate.isBefore(randevuList[i]['startTime']
                    .toDate()
                    .add(Duration(minutes: randevuList[i]['duration'])))) ||
            (fullDate
                    .add(Duration(minutes: widget.selectedHizmet['sure']))
                    .isAfter(randevuList[i]['startTime'].toDate()) &&
                fullDate
                    .add(Duration(minutes: widget.selectedHizmet['sure']))
                    .isBefore(randevuList[i]['startTime']
                        .toDate()
                        .add(Duration(minutes: randevuList[i]['duration']))))) {
          conflict = true;
          setState(() {
            validTime = false;
          });
          break;
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

      for (int i = 0; i < randevuList.length; i++) {
        if ((fullDate.isAfter(randevuList[i]['startTime'].toDate()) &&
                fullDate.isBefore(randevuList[i]['startTime']
                    .toDate()
                    .add(Duration(minutes: randevuList[i]['duration'])))) ||
            (fullDate
                    .add(Duration(minutes: widget.selectedHizmet['sure']))
                    .isAfter(randevuList[i]['startTime'].toDate()) &&
                fullDate
                    .add(Duration(minutes: widget.selectedHizmet['sure']))
                    .isBefore(randevuList[i]['startTime']
                        .toDate()
                        .add(Duration(minutes: randevuList[i]['duration']))))) {
          conflict = true;
          setState(() {
            validTime = false;
          });
          break;
        }
      }

      if(fullDate.hour > 17 || fullDate.hour < 9){
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

    for (int i = 0; i < randevuList.length; i++) {
      meetings.add(Appointment(
          startTime: randevuList[i]['startTime'].toDate(),
          endTime: randevuList[i]['startTime']
              .toDate()
              .add(Duration(minutes: randevuList[i]['duration'])),
          subject: 'Dolu',
          color: Colors.red,
          isAllDay: false));
    }
    meetings.add(Appointment(
        startTime: selectedDate,
        endTime:
            selectedDate.add(Duration(minutes: widget.selectedHizmet['sure'])),
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

List<Appointment> getAppointments(
    dynamic hocaRef, DateTime selectedDate, Map selectedHizmet) {
  List<Appointment> meetings = <Appointment>[];
  dynamic randevuList = <Map>[];
  randevuList = hocaRef['Randevular'];

  for (int i = 0; i < randevuList.length; i++) {
    meetings.add(Appointment(
        startTime: randevuList[i]['startTime'].toDate(),
        endTime: randevuList[i]['startTime']
            .toDate()
            .add(Duration(minutes: randevuList[i]['duration'])),
        subject: 'Dolu',
        color: Colors.red,
        isAllDay: false));
  }
  meetings.add(Appointment(
      startTime: selectedDate,
      endTime: selectedDate.add(Duration(minutes: selectedHizmet['sure'])),
      subject: 'Seçilen Tarih',
      color: Colors.blue,
      isAllDay: false));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

