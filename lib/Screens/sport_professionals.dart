import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randebul/Screens/professional_profile.dart';
//import 'package:randebul/Screens/home_screen.dart';

class SportProfessionals extends StatefulWidget {
  final String name;
  final String surname;
  final int puan;

  const SportProfessionals({
    Key? key,
    this.name = '',
    this.surname = '',
    this.puan = 5,
  }) : super(key: key);

  @override
  State<SportProfessionals> createState() => _SportProfessionalsState();
}

class _SportProfessionalsState extends State<SportProfessionals> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference hocaRef = _firestore.collection('professionals');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sports Professionals'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: hocaRef.snapshots(),
          builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
            if (asyncSnapshot.hasError) {
              return const Center(
                  child: Text('Bir Hata Oluştu. Lütfen Tekrar Deneyin.'));
            } else {
              if (asyncSnapshot.hasData) {
                dynamic hocaList = asyncSnapshot.data.docs;
                return ListView.builder(
                    itemCount: hocaList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        color: Colors.yellow,
                        child: ListTile(
                          title: Text(
                            '${hocaList[index].data()['name']} ${hocaList[index].data()['surname']}',
                            style: const TextStyle(fontSize: 28),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${hocaList[index].data()['profession']}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                  (hocaList[index].data()['comments'] != null)
                                ? 'Rating: ${(hocaList[index].data()['point'] / hocaList[index].data()['comments'].length).toStringAsFixed(1)}'
                                  : 'Rating: N/A',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfessionalProfile(
                                        hocaRef: hocaList[index].data(),
                                        hocaSnapshot: hocaList[index])));
                          },
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          }),
    );
  }
}
