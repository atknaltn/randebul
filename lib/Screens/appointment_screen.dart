import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randebul/Screens/selectdate.dart';
//import 'package:randebul/Screens/home_screen.dart';

class AppointmentScreen extends StatefulWidget {
  final dynamic hocaRef;
  final DocumentSnapshot hocaSnapshot;
  const AppointmentScreen({
    Key? key,
    required this.hocaRef,
    required this.hocaSnapshot,
  }) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  dynamic hizmetList = <Map>[];
  bool isSelected = false;
  int selectedIndex = 0;
  Map selectedHizmet = {'başlık': '', 'sure': 0, 'icerik': '', 'fiyat': 0};
  @override
  Widget build(BuildContext context) {
    hizmetList = widget.hocaRef['hizmetler'];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Randevu Al'),
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
                      child: ('${widget.hocaRef['imageURL']}' != '' && '${widget.hocaRef['imageURL']}' != 'null')
                          ? Image.network(
                              '${widget.hocaRef['imageURL']}',
                              height: 150,
                            )
                          : Image.asset(
                              'assets/blankprofile.png',
                              height: 150,
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
                              '${widget.hocaRef['name']} ${widget.hocaRef['surname']}',
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
                              '${widget.hocaRef['profession']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Text(
                              'Puan: ${widget.hocaRef['point']}',
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
                  'Hizmet Seçiniz',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          if (hizmetList == null || hizmetList.isEmpty)
            Column(
              children: const [
                SizedBox(height: 100),
                Text(
                  'Bu profesyonel henüz hizmet vermemektedir.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            )
          else
            for (int index = 0; index < hizmetList.length; index++)
              GestureDetector(
                child: ServiceBox(
                  serviceName: '${hizmetList[index]['başlık']}',
                  duration: '${hizmetList[index]['sure']}',
                  icerik: '${hizmetList[index]['icerik']}',
                  fiyat: '${hizmetList[index]['fiyat']}',
                  isSelected:
                      (selectedIndex == index && isSelected) ? true : false,
                ),
                onTap: () {
                  selectedHizmet = hizmetList[index];
                  selectedIndex = index;
                  setState(() {
                    isSelected = !isSelected;
                  });
                },
              ),
        ],
      ),
      floatingActionButton: (isSelected)
          ? FloatingActionButton.extended(
              label: const Text('İlerle'),
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectDatePage(
                            selectedHizmet: selectedHizmet,
                            hocaRef: widget.hocaRef,
                            hocaSnapshot: widget.hocaSnapshot)));
              })
          : null,
    );
  }
}

/*Hizmetlerin yer aldığı yeşil kutucuklar.*/
class ServiceBox extends StatelessWidget {
  final String serviceName;
  final String duration;
  final String icerik;
  final String fiyat;
  final bool isSelected;
  final int index;

  const ServiceBox({
    Key? key,
    this.serviceName = '',
    this.duration = '',
    this.icerik = '',
    this.fiyat = '',
    this.isSelected = false,
    this.index = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: 200,
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
