import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'all_comments.dart';
import 'editprofile.dart';
import 'upgrade_pro.dart';
//import 'package:randebul/Screens/home_screen.dart';

class MyProfileCustomer extends StatefulWidget {
  const MyProfileCustomer(
      {Key? key})
      : super(key: key);
  @override
  State<MyProfileCustomer> createState() => _MyProfileCustomerState();
}

class _MyProfileCustomerState extends State<MyProfileCustomer> {
  String firstname = "";
  String lastname = "";
  String mail = "";
  String phoneNumber = "";
  String address = "";
  String userName = "";
  String image = "";
  String uid = "";
  bool verified = false;
  dynamic ref;
  var response2;
  Future<void> _getUserName() async {
    CollectionReference temp3 =
    FirebaseFirestore.instance.collection('users');
    DocumentReference temp4 =
    temp3.doc((FirebaseAuth.instance.currentUser)!.uid);
    response2 = await temp4.get();
    ref = response2.data();
    setState(() {
      firstname = ref['firstName'];
      lastname = ref['surName'];
      mail = ref['email'];
      phoneNumber = ref['phoneNumber'];
      address = ref['adress'];
      userName = ref['userName'];
      uid = ref['uid'];
      if(ref['imageURL'] != null) {
        image = ref['imageURL'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _getUserName();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('My Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: ListView(
              children: [
                UstKart(
                  resimAdresi: image,
                  verified: verified,
                  isim: firstname + " " + lastname,
                  username: userName,
                ),
                const SizedBox(height: 30),
                const SizedBox(height: 30),
                IletisimBilgileri(
                  telNo: phoneNumber,
                  email: mail,
                  address: address,
                ),
                const SizedBox(height: 30),
                const SizedBox(height: 30),
                const SizedBox(height: 50),
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                EditProfile(firstname, lastname, mail, uid)),
                      );
                    },
                    child: const IconText(
                        icon: Icons.edit, text: 'Edit Profile'),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: GestureDetector(
                      onTap: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UpgradePro(),
                        ));
                      },
                      child: const IconText(
                          icon: Icons.upgrade, text: 'Upgrade Pro')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  } //Your code here
}

/*Sayfanın üstünde profil resmi, isim, username, meslek ve konum bulunan bölüm.*/
class UstKart extends StatelessWidget {
  final bool verified;
  final String resimAdresi;
  final String isim;
  final String username;

  const UstKart({
    Key? key,
    this.verified = false,
    this.resimAdresi = 'assets/blankprofile.png',
    this.isim = '',
    this.username = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          child: (resimAdresi != '' && resimAdresi != 'null')
              ? Image.network(
            resimAdresi,
            height: 150,
          )
              : Image.asset(
            'assets/blankprofile.png',
            height: 150,
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
              const SizedBox(height: 10),
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
            'About',
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
  final String address;

  const IletisimBilgileri(
      {Key? key,
        this.telNo = '',
        this.email = '',
        this.address = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyCard(cardIcon: Icons.phone, cardText: telNo),
        MyCard(cardIcon: Icons.mail, cardText: email),
        MyCard(cardIcon: Icons.location_pin, cardText: address,),
      ],
    );
  }
}

/*2 yorum kartından oluşan son yorumlar bölümü.*/
class Yorumlar extends StatelessWidget {
  final dynamic hocaRef;

  const Yorumlar({Key? key, required this.hocaRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic yorumlar = <Map>[];
    yorumlar = hocaRef['comments'];

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
              'Last Comments',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            (yorumlar == null || yorumlar.isEmpty)
                ? const Text('This professional haven\'t got any comments yet.')
                : YorumKart(
                username: yorumlar[yorumlar.length - 1]['username'],
                tarih: yorumlar[yorumlar.length - 1]['date'],
                puan: yorumlar[yorumlar.length - 1]['point'],
                yorumMetni: yorumlar[yorumlar.length - 1]['comment']),
            const SizedBox(
              height: 5,
            ),
            (yorumlar != null && yorumlar.length >= 2)
                ? YorumKart(
                username: yorumlar[yorumlar.length - 2]['username'],
                tarih: yorumlar[yorumlar.length - 2]['date'],
                puan: yorumlar[yorumlar.length - 2]['point'],
                yorumMetni: yorumlar[yorumlar.length - 2]['comment'])
                : const SizedBox(height: 5),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllCommentsPage(hocaRef: hocaRef))),
              child: const Text(
                'SEE ALL COMMENTS',
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
                      'Username: ',
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
                  'Rating: ',
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
