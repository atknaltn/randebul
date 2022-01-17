import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'appointment_screen.dart';

class ConfirmAndPay extends StatefulWidget {
  final dynamic hocaRef;
  final Map selectedHizmet;
  final DateTime selectedDate;
  final DocumentSnapshot hocaSnapshot;
  final int sourcePlace;
  const ConfirmAndPay({
    Key? key,
    required this.hocaSnapshot,
    required this.hocaRef,
    required this.selectedHizmet,
    required this.selectedDate,
    required this.sourcePlace,
  }) : super(key: key);
  @override
  _ConfirmAndPayState createState() => _ConfirmAndPayState();
}

class _ConfirmAndPayState extends State<ConfirmAndPay> {
  dynamic userBalance = 0;
  bool enoughMoney = true;

  Future<void> _getUserBalance() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc((FirebaseAuth.instance.currentUser)!.uid)
        .get()
        .then((value) {
      setState(() {
        userBalance = value.data()!['amount'];
      });
    });
  }

  Future<void> updateUserProfile() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc((FirebaseAuth.instance.currentUser)!.uid)
        .update({
      'amount': userBalance - widget.selectedHizmet['servicePrice'],
      'Randevular': FieldValue.arrayUnion([
        {
          'duration': widget.selectedHizmet['serviceDuration'],
          'startTime': widget.selectedDate,
          'subject': widget.selectedHizmet['serviceName'],
          'profesyonel': FirebaseFirestore.instance
              .collection('spor-hocalari-deneme')
              .doc(widget.hocaSnapshot.id)
              .path,
        }
      ])
    });
  }

  Future<void> updateProfProfile() async {
    DocumentReference musteriRef = FirebaseFirestore.instance
        .collection('users')
        .doc((FirebaseAuth.instance.currentUser)!.uid);

    FirebaseFirestore.instance
        .collection('professionals')
        .doc(widget.hocaSnapshot.id)
        .update({
      'amount': FieldValue.increment(widget.selectedHizmet['servicePrice']),
      'Randevular': FieldValue.arrayUnion([
        {
          'duration': widget.selectedHizmet['serviceDuration'],
          'startTime': widget.selectedDate,
          'subject': widget.selectedHizmet['serviceName'],
          'musteri': musteriRef.path,
        }
      ])
    });
  }

  void checkEnoughMoney() {
    dynamic ucret = widget.selectedHizmet['servicePrice'];
    if (ucret > userBalance) {
      setState(() {
        enoughMoney = false;
      });
    } else {
      setState(() {
        enoughMoney = true;
      });
    }
  }

  @override
  Widget build(BuildContext contextt) {
    _getUserBalance();
    checkEnoughMoney();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm and Pay'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Selected Appointment',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          ServiceBox(
            serviceName: '${widget.selectedHizmet['serviceName']}',
            duration: '${widget.selectedHizmet['serviceDuration']}',
            serviceContent: '${widget.selectedHizmet['serviceContent']}',
            servicePrice: '${widget.selectedHizmet['servicePrice']}',
            tarih: widget.selectedDate,
            profesyonel:
                '${widget.hocaRef['name']} ${widget.hocaRef['surname']}',
            isSelected: true,
            index: 0,
          ),
          Center(
            child: Text(
              'Your Balance:   $userBalance',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Center(
            child: Text(
              'Service Price:           ${widget.selectedHizmet['servicePrice']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          (enoughMoney)
              ? const Center(
                  child: Text('You can get this appointment.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )))
              : const Center(
                  child: Text('You don\'t have enough money on your account.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ))),
          const SizedBox(height: 20),
          (enoughMoney)
              ? TextButton(
                  child: Container(
                    color: Colors.blue,
                    height: 100,
                    width: 10000,
                    child: const Center(
                      child: Text(
                        'Confirm Appointment',
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  onPressed: () {
                    updateUserProfile();
                    updateProfProfile();
                    showDialog(
                      context: contextt,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Success'),
                          content: const SizedBox(
                            height: 80,
                            child: Text('Appointment was made successfully.'),
                          ),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  if(widget.sourcePlace == 0) {
                                    Navigator.pop(contextt);
                                    Navigator.pop(contextt);
                                    Navigator.pop(contextt);
                                    Navigator.pop(contextt);
                                    Navigator.pop(contextt);
                                  }
                                  else if (widget.sourcePlace == 1) {
                                    Navigator.pop(contextt);
                                    Navigator.pop(contextt);
                                  }
                                },
                                child: const Text('Go back to Home Page'))
                          ],
                        );
                      },
                    );
                  },
                )
              : const SizedBox(height: 20),
        ],
      )
    );
  }
}

/*Hizmetlerin yer aldığı yeşil kutucuklar.*/
class ServiceBox extends StatelessWidget {
  final String serviceName;
  final String duration;
  final String serviceContent;
  final String servicePrice;
  final bool isSelected;
  final int index;
  final String profesyonel;
  final DateTime tarih;

  const ServiceBox({
    Key? key,
    this.serviceName = '',
    this.duration = '',
    this.serviceContent = '',
    this.servicePrice = '',
    this.isSelected = false,
    this.index = 0,
    this.profesyonel = '',
    required this.tarih,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: 250,
      decoration: BoxDecoration(
          color: (!isSelected) ? Colors.green : Colors.lime,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          const SizedBox(height: 5),
          Text(
            serviceName,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          MyCard(
            cardIcon: Icons.alarm,
            tur: 'Duration: ',
            cardText: '$duration dk.',
          ),
          const SizedBox(height: 5),
          MyCard(
            cardIcon: Icons.home_repair_service_outlined,
            tur: 'Content: ',
            cardText: serviceContent,
          ),
          const SizedBox(height: 5),
          MyCard(
            cardIcon: Icons.attach_money,
            tur: 'Price: ',
            cardText: '\$$servicePrice',
          ),
          const SizedBox(height: 5),
          MyCard(
            cardIcon: Icons.person,
            tur: 'Professional: ',
            cardText: profesyonel,
          ),
          const SizedBox(height: 5),
          MyCard(
            cardIcon: Icons.calendar_today,
            tur: 'Date: ',
            cardText: DateFormat('dd.MM.y - HH:mm').format(tarih),
          ),
        ],
      ),
    );
  }
}
