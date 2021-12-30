import 'package:flutter/material.dart';
import 'package:randebul/Screens/appointment_screen.dart';

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

  @override
  Widget build(BuildContext context) {
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
                    'Lütfen Geçerli Bir Saat Seçiniz:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
          Center(
            child: Text(
              'Seçili Tarih: ${selectedDate.day}.${selectedDate.month}.${selectedDate.year} - ${selectedDate.hour}:${selectedDate.minute}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
        ],
      ),
    );
  }

  _openDatePicker(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2023),
    );

    if (date != null) {
      setState(() {
        selectedDate = DateTime(date.year, date.month, date.day,
            selectedDate.hour, selectedDate.minute);
      });
    }
  }

  _openTimePicker(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute),
      builder: (BuildContext context, Widget? child){
        return Theme(
          data: ThemeData(),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
        );
      }
    );

    if (time != null) {
      if (time.hour < DateTime.now().hour || (time.hour == DateTime.now().hour &&
          time.minute < DateTime.now().minute)) {
        setState(() {
          validTime = false;
        });
      }
      else {
        setState(() {
          selectedDate = DateTime(selectedDate.year, selectedDate.month,
              selectedDate.day, time.hour, time.minute);
          validTime = true;
        });
      }
    }
  }
}
