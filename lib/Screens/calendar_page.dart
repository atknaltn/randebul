import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    Key? key,
  }) : super(key: key);
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  dynamic veri;
  dynamic veri2;
  CalendarView gorunum = CalendarView.week;

  String? _subjectText = '',
      _startTimeText = '',
      _endTimeText = '',
      _dateText = '',
      _timeDetails = '',
      _contentText = '';

  @override
  Widget build(BuildContext context) {
    getFireBase();
    getProfRandevu();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
        },
      ),
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Center(
            child: Text('Kırmızı: Alınan Randevular',
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold
              ),),
          ),
          const Center(
            child: Text('Mavi: Verilen Randevular',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold
              ),),
          ),
          Expanded(
            child: SfCalendar(
              appointmentTimeTextFormat: 'hh:mm',
              view: gorunum,
              firstDayOfWeek: DateTime.now().weekday,
              timeSlotViewSettings: const TimeSlotViewSettings(
                timeInterval: Duration(minutes: 30),
                timeFormat: 'HH:mm',
                dayFormat: 'EEE',
                startHour: 9,
                endHour: 18,
              ),
              dataSource: MeetingDataSource(getAppointments()),
              onTap: calendarTapped,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getFireBase() async {
    CollectionReference temp1 = FirebaseFirestore.instance.collection('users');
    DocumentReference temp2 =
        temp1.doc((FirebaseAuth.instance.currentUser)!.uid);
    var response = await temp2.get();
    veri = response.data();
    setState(() {});
  }

  Future<void> getProfRandevu() async{
    CollectionReference temp1 = FirebaseFirestore.instance.collection('professionals');
    DocumentReference temp2 =
    temp1.doc((FirebaseAuth.instance.currentUser)!.uid);
    var response = await temp2.get();
    veri2 = response.data();
    setState(() {});
}

  List<Appointment> getAppointments() {
    List<Appointment> meetings = <Appointment>[];
    dynamic randevuList = <Map>[];
    if (veri != null) {
      randevuList = veri['Randevular'];

      if (veri['Randevular'] != null) {
        for (int i = 0; i < randevuList.length; i++) {
          meetings.add(Appointment(
            location: randevuList[i]['subject'],
              startTime: randevuList[i]['startTime'].toDate(),
              endTime: randevuList[i]['startTime']
                  .toDate()
                  .add(Duration(minutes: randevuList[i]['duration'])),
              subject: randevuList[i]['subject'],
              color: Colors.red,
              notes: randevuList[i]['profName'] + ' ' + randevuList[i]['profSurname'],
              isAllDay: false));
        }
      }
    }
    if (veri2 != null) {
      randevuList = veri2['Randevular'];
      if (veri2['Randevular'] != null) {
        for (int i = 0; i < randevuList.length; i++) {
          meetings.add(Appointment(
              location: randevuList[i]['subject'],
              startTime: randevuList[i]['startTime'].toDate(),
              endTime: randevuList[i]['startTime']
                  .toDate()
                  .add(Duration(minutes: randevuList[i]['duration'])),
              subject: randevuList[i]['subject'],
              color: Colors.blue,
              notes: randevuList[i]['musteriName'] + ' ' + randevuList[i]['musteriSurame'],
              isAllDay: false));
        }
      }
    }
    return meetings;
  }

  Future<void> getName(String? path) async{
    CollectionReference temp1 = FirebaseFirestore.instance
        .collection('users');
    DocumentReference temp2 = temp1.doc(path);
    var response = await temp2.get();
    dynamic temp = response.data();
    _contentText = temp['name'];
    setState(() {});
  }

  Future<void> calendarTapped(CalendarTapDetails details) async {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Appointment appointmentDetails = details.appointments![0];
      _contentText= appointmentDetails.notes;
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
              title: Center(child: Text('$_subjectText')),
              content: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    Text(
                      '$_contentText',
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$_dateText',
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(_timeDetails!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15))
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
