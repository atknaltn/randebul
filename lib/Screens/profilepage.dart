import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'appointment_screen.dart';
//import 'package:randebul/Screens/home_screen.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);
  HomePage createState() => HomePage();
}

class HomePage extends State<ProfilePage> {
  //User user = FirebaseAuth.instance.currentUser!;
  String firstname = "";
  String lastname = "";
  String mail = "";
  String phoneNumber = "";
  String address = "";
  String userName = "";
  Future<void> _getUserName() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc((await FirebaseAuth.instance.currentUser)!.uid)
        .get()
        .then((value) {
      setState(() {
        firstname = value.data()!['firstName'].toString();
        lastname = value.data()!['surName'].toString();
        mail = value.data()!['email'].toString();
        phoneNumber = value.data()!['phoneNumber'].toString();
        address = value.data()!['adress'].toString();
        userName = value.data()!['userName'].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _getUserName();
    print(firstname);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text('My Profile'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.edit,
              ),
              onPressed: () {
                print('Editbutton');
              },
            ),
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
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Categories'),
              ),
              ListTile(
                title: const Text('Health'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Education'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sports'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Music'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: ListView(
                children: [
                  UstKart(
                    puan: 8.5,
                    resimAdresi: 'assets/blankprofile.png',
                    verified: true,
                    isim: firstname + " " + lastname,
                    username: userName,
                    proffession: '',
                    location: address,
                  ),
                  const SizedBox(height: 30),
                  const Hakkinda(hakkindaYazisi: ''),
                  const SizedBox(height: 30),
                  IletisimBilgileri(
                    telNo: phoneNumber,
                    email: mail,
                    website: '',
                    address: address,
                  ),
                  const SizedBox(height: 30),
                  const Yorumlar(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        print('tapped1');
                      },
                      child: const IconText(
                          icon: Icons.comment, text: 'Yorum Yap'),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AppointmentScreen(
                                      isim: 'Savaş Cebeci',
                                      proffession: 'Personal Trainer',
                                      puan: 8)));
                        },
                        child: const IconText(
                            icon: Icons.calendar_today, text: 'Randevu Al')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  } //Your code here
}

/*Sayfanın üstünde profil resmi, isim, username, meslek ve konum bulunan bölüm.*/
class UstKart extends StatelessWidget {
  final double puan;
  final bool verified;
  final String resimAdresi;
  final String isim;
  final String username;
  final String proffession;
  final String location;

  const UstKart({
    Key? key,
    this.puan = 5,
    this.verified = false,
    this.resimAdresi = '',
    this.isim = '',
    this.username = '',
    this.proffession = '',
    this.location = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            child: Image.asset(
              resimAdresi,
              height: 150,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (verified == true)
                      ? const Icon(
                          Icons.verified,
                          color: Colors.blue,
                        )
                      : const Text(''),
                  Text(
                    isim,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text('@$username'),
              const SizedBox(height: 10),
              Text(proffession),
              Text(location),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('Puan: $puan '),
                  (puan < 1)
                      ? const Icon(Icons.star_border, color: Colors.yellow)
                      : (puan <= 1)
                          ? const Icon(Icons.star_half, color: Colors.yellow)
                          : const Icon(Icons.star, color: Colors.yellow),
                  (puan <= 2)
                      ? const Icon(Icons.star_border, color: Colors.yellow)
                      : (puan <= 3)
                          ? const Icon(Icons.star_half, color: Colors.yellow)
                          : const Icon(Icons.star, color: Colors.yellow),
                  (puan <= 4)
                      ? const Icon(Icons.star_border, color: Colors.yellow)
                      : (puan <= 5)
                          ? const Icon(Icons.star_half, color: Colors.yellow)
                          : const Icon(Icons.star, color: Colors.yellow),
                  (puan <= 6)
                      ? const Icon(Icons.star_border, color: Colors.yellow)
                      : (puan <= 7)
                          ? const Icon(Icons.star_half, color: Colors.yellow)
                          : const Icon(Icons.star, color: Colors.yellow),
                  (puan <= 8)
                      ? const Icon(Icons.star_border, color: Colors.yellow)
                      : (puan <= 9)
                          ? const Icon(Icons.star_half, color: Colors.yellow)
                          : const Icon(Icons.star, color: Colors.yellow),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/*Hakkında bölümü.*/
class Hakkinda extends StatelessWidget {
  final String hakkindaYazisi;

  const Hakkinda({Key? key, this.hakkindaYazisi = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          const Text(
            'Hakkında',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(hakkindaYazisi),
        ],
      ),
    );
  }
}

/*İletişim bilgileri kartlarının bulunduğu bölüm.*/
class IletisimBilgileri extends StatelessWidget {
  final String telNo;
  final String email;
  final String website;
  final String address;

  const IletisimBilgileri(
      {Key? key,
      this.telNo = '',
      this.email = '',
      this.website = '',
      this.address = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyCard(cardIcon: Icons.phone, cardText: telNo),
        MyCard(cardIcon: Icons.mail, cardText: email),
        MyCard(cardIcon: Icons.link, cardText: website),
        MyCard(
          cardIcon: Icons.location_pin,
          cardText: address,
        ),
      ],
    );
  }
}

/*2 yorum kartından oluşan son yorumlar bölümü.*/
class Yorumlar extends StatelessWidget {
  const Yorumlar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blueGrey,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Son Yorumlar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const YorumKart(
                username: 'xyz123',
                tarih: '30 Ekim 2021',
                puan: 9,
                yorumMetni:
                    'Savaş Hoca çok iyiydi. Savaş Hoca çok iyiydi. Savaş Hoca çok iyiydi. Savaş Hoca çok iyiydi. Savaş Hoca çok iyiydi. Savaş Hoca çok iyiydi. Savaş Hoca çok iyiydi. '),
            const SizedBox(
              height: 5,
            ),
            const YorumKart(
                username: 'Anonim',
                tarih: '28 Ekim 2021',
                puan: 4,
                yorumMetni:
                    'Savaş Hoca pek iyi değildi. Savaş Hoca pek iyi değildi. Savaş Hoca pek iyi değildi. Savaş Hoca pek iyi değildi. Savaş Hoca pek iyi değildi. '),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                print('tapped3');
              },
              child: const Text(
                'TÜM YORUMLARI GÖR',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

/*İletişim bilgilerinin bulunduğu kart widget.*/
class MyCard extends StatelessWidget {
  final IconData cardIcon;
  final String cardText;

  const MyCard({Key? key, this.cardIcon = Icons.email, this.cardText = ''})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.blue,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            Icon(cardIcon),
            const SizedBox(width: 10),
            Text(
              cardText,
            ),
          ],
        ),
      ),
    );
  }
}

/*Randevu al ve Yorum Yap butonunun olduğu, bir ikon bir text'ten oluşan widget.*/
class IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconText({Key? key, this.icon = Icons.email, this.text = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 35,
          ),
          const SizedBox(height: 5.0),
          Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/*Bir yorum içeren widget.*/
class YorumKart extends StatelessWidget {
  final int puan;
  final String username;
  final String tarih;
  final String yorumMetni;

  const YorumKart(
      {Key? key,
      this.puan = 5,
      this.username = '',
      this.tarih = '',
      this.yorumMetni = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 10),
                    const Text(
                      'Kullanıcı adı: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(username),
                  ],
                ),
                Row(children: [
                  Text(tarih),
                  const SizedBox(width: 10),
                ]),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(width: 10),
                const Text(
                  'Puanı: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                (puan < 1)
                    ? const Icon(Icons.star_border, color: Colors.yellow)
                    : (puan == 1)
                        ? const Icon(Icons.star_half, color: Colors.yellow)
                        : const Icon(Icons.star, color: Colors.yellow),
                (puan <= 2)
                    ? const Icon(Icons.star_border, color: Colors.yellow)
                    : (puan == 3)
                        ? const Icon(Icons.star_half, color: Colors.yellow)
                        : const Icon(Icons.star, color: Colors.yellow),
                (puan <= 4)
                    ? const Icon(Icons.star_border, color: Colors.yellow)
                    : (puan == 5)
                        ? const Icon(Icons.star_half, color: Colors.yellow)
                        : const Icon(Icons.star, color: Colors.yellow),
                (puan <= 6)
                    ? const Icon(Icons.star_border, color: Colors.yellow)
                    : (puan == 7)
                        ? const Icon(Icons.star_half, color: Colors.yellow)
                        : const Icon(Icons.star, color: Colors.yellow),
                (puan <= 8)
                    ? const Icon(Icons.star_border, color: Colors.yellow)
                    : (puan == 9)
                        ? const Icon(Icons.star_half, color: Colors.yellow)
                        : const Icon(Icons.star, color: Colors.yellow),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Flexible(child: Text('"$yorumMetni"')),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
