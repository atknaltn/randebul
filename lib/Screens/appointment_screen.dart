import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:randebul/Screens/home_screen.dart';

class AppointmentScreen extends StatefulWidget {
  final String isim;
  final String proffession;
  final int puan;

  const AppointmentScreen({
    Key? key,
    this.isim = '',
    this.proffession = '',
    this.puan = 5,
  }) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference hizmetlerRef = _firestore.collection('hasan-hizmetler');
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Randevu Al'),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              padding: const EdgeInsets.only(right: 15, left: 15),
              tooltip: 'Back',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            Container(
              height: 225,
              decoration: const BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10, top: 10),
                        child: Image.asset(
                          "assets/testProfile.jpg",
                          height: 150,
                          width: 150,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: Text(
                                widget.isim,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                widget.proffession,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: Text(
                                'Puan: ${widget.puan}',
                                style: const TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Hizmetler',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: hizmetlerRef.snapshots(),
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    return const Center(
                        child: Text('Bir Hata Oluştu. Lütfen Tekrar Deneyin.'));
                  } else {
                    if (asyncSnapshot.hasData) {
                      dynamic hizmetList = asyncSnapshot.data.docs;
                      return Flexible(
                        child: ColumnBuilder(

                            itemCount: hizmetList.length,
                            itemBuilder: (context, index) {
                              return ServiceBox(
                                serviceName: '${hizmetList[index].data()['name']}',
                                duration: '${hizmetList[index].data()['sure']}',
                                icerik: '${hizmetList[index].data()['icerik']}',
                                fiyat: '${hizmetList[index].data()['fiyat']}',
                              );
                            }),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }
}

// Yeşil kutucuklar
class ServiceBox extends StatelessWidget {
  final String serviceName;
  final String duration;
  final String icerik;
  final String fiyat;

  const ServiceBox({
    Key? key,
    this.serviceName = '',
    this.duration = '',
    this.icerik = '',
    this.fiyat = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: 200,
      decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(10))),
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
            tur: 'Süre: ',
            cardText: '$duration dk.',
          ),
          const SizedBox(height: 5),
          MyCard(
            cardIcon: Icons.home_repair_service_outlined,
            tur: 'İçerik: ',
            cardText: icerik,
          ),
          const SizedBox(height: 5),
          MyCard(
            cardIcon: Icons.attach_money,
            tur: 'Fiyat: ',
            cardText: '\$$fiyat',
          ),
        ],
      ),
    );
  }
}

// Yeşil kutucukların içindeki satır satır yazılar.
class MyCard extends StatelessWidget {
  final IconData cardIcon;
  final String tur;
  final String cardText;

  const MyCard(
      {Key? key,
      this.cardIcon = Icons.email,
      this.tur = '',
      this.cardText = ''})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 10),
          Icon(cardIcon),
          const SizedBox(width: 10),
          Text(
            tur,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: Text(
              cardText,
            ),
          ),
        ],
      ),
    );
  }
}

// Bunu internettem buldum tüm sayfayı birden kaydırabilmek için gerekliydi
class ColumnBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final VerticalDirection verticalDirection;
  final int itemCount;

  const ColumnBuilder({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount,
              (index) => itemBuilder(context, index)).toList(),
    );
  }
}