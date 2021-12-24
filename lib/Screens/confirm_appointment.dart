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
            child: Text('Seçilen Randevu',
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
            child: Text('Seçilen Profesyonel: ${widget.hocaRef['name']} ${widget.hocaRef['surname']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
