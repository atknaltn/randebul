import 'package:flutter/material.dart';
import 'package:randebul/Screens/home_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('My Profile'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit,
              ),
              onPressed: () {
                print('Editbutton');
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
                children: const [
                  UstKart(
                    puan: 8.5,
                    resimAdresi: 'assets/testProfile.jpg',
                    verified: true,
                    isim: 'Savaş Cebeci',
                    username: 'savascebeci',
                    proffession: 'Personal Trainer',
                    location: 'İstanbul',
                  ),
                  SizedBox(height: 30),
                  Hakkinda(
                      hakkindaYazisi:
                          'İş yaşamında efektif ve hızlı olmak konusunda son derece özverili ve hevesli olduğumu, pozisyonun gerektirdiği sorumluluğu merak ve istekle üzerime almak istediğimi belirtmek isterim. İstekli, özenli ve dikkatli çalışmanın mutlaka başarı ile sonuçlanacağının bilincindeyim. Bu nedenle size yeteneklerim ve çalışma disiplinim ile katkı sağlayabileceğim noktasında şüphem yok.'),
                  SizedBox(height: 30),
                  IletisimBilgileri(
                    telNo: '599 999 99 99',
                    email: 'savascebeci@gmail.com',
                    website: 'savascebeci.com',
                    address: 'Kaslı Mah. Demir Sok. 93/3',
                  ),
                  SizedBox(height: 30),
                  Yorumlar(),
                  SizedBox(height: 30),
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
                        child:
                            IconText(icon: Icons.comment, text: 'Yorum Yap')),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          print('tapped2');
                        },
                        child: IconText(
                            icon: Icons.calendar_today, text: 'Randevu Al')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
            margin: EdgeInsets.all(10.0),
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
                      ? Icon(
                          Icons.verified,
                          color: Colors.blue,
                        )
                      : Text(''),
                  Text(
                    isim,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text('@$username'),
              SizedBox(height: 10),
              Text(proffession),
              Text(location),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Puan: $puan '),
                  (puan < 1)
                      ? Icon(Icons.star_border, color: Colors.yellow)
                      : (puan <= 1)
                          ? Icon(Icons.star_half, color: Colors.yellow)
                          : Icon(Icons.star, color: Colors.yellow),
                  (puan <= 2)
                      ? Icon(Icons.star_border, color: Colors.yellow)
                      : (puan <= 3)
                          ? Icon(Icons.star_half, color: Colors.yellow)
                          : Icon(Icons.star, color: Colors.yellow),
                  (puan <= 4)
                      ? Icon(Icons.star_border, color: Colors.yellow)
                      : (puan <= 5)
                          ? Icon(Icons.star_half, color: Colors.yellow)
                          : Icon(Icons.star, color: Colors.yellow),
                  (puan <= 6)
                      ? Icon(Icons.star_border, color: Colors.yellow)
                      : (puan <= 7)
                          ? Icon(Icons.star_half, color: Colors.yellow)
                          : Icon(Icons.star, color: Colors.yellow),
                  (puan <= 8)
                      ? Icon(Icons.star_border, color: Colors.yellow)
                      : (puan <= 9)
                          ? Icon(Icons.star_half, color: Colors.yellow)
                          : Icon(Icons.star, color: Colors.yellow),
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
          Text(
            'Hakkında',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
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
            SizedBox(
              height: 15,
            ),
            Text(
              'Son Yorumlar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            YorumKart(
                username: 'xyz123',
                tarih: '30 Ekim 2021',
                puan: 9,
                yorumMetni:
                    'Savaş Hoca çok iyiydi. Savaş Hoca çok iyiydi. Savaş Hoca çok iyiydi. Savaş Hoca çok iyiydi. Savaş Hoca çok iyiydi. Savaş Hoca çok iyiydi. Savaş Hoca çok iyiydi. '),
            SizedBox(
              height: 5,
            ),
            YorumKart(
                username: 'Anonim',
                tarih: '28 Ekim 2021',
                puan: 4,
                yorumMetni:
                    'Savaş Hoca pek iyi değildi. Savaş Hoca pek iyi değildi. Savaş Hoca pek iyi değildi. Savaş Hoca pek iyi değildi. Savaş Hoca pek iyi değildi. '),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                print('tapped3');
              },
              child: Text(
                'TÜM YORUMLARI GÖR',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
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
            SizedBox(width: 10),
            Icon(cardIcon),
            SizedBox(width: 10),
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
          SizedBox(height: 5.0),
          Text(
            text,
            style: TextStyle(
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
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 10),
                    Text(
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
                  SizedBox(width: 10),
                ]),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 10),
                Text(
                  'Puanı: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5),
                (puan < 1)
                    ? Icon(Icons.star_border, color: Colors.yellow)
                    : (puan == 1)
                        ? Icon(Icons.star_half, color: Colors.yellow)
                        : Icon(Icons.star, color: Colors.yellow),
                (puan <= 2)
                    ? Icon(Icons.star_border, color: Colors.yellow)
                    : (puan == 3)
                        ? Icon(Icons.star_half, color: Colors.yellow)
                        : Icon(Icons.star, color: Colors.yellow),
                (puan <= 4)
                    ? Icon(Icons.star_border, color: Colors.yellow)
                    : (puan == 5)
                        ? Icon(Icons.star_half, color: Colors.yellow)
                        : Icon(Icons.star, color: Colors.yellow),
                (puan <= 6)
                    ? Icon(Icons.star_border, color: Colors.yellow)
                    : (puan == 7)
                        ? Icon(Icons.star_half, color: Colors.yellow)
                        : Icon(Icons.star, color: Colors.yellow),
                (puan <= 8)
                    ? Icon(Icons.star_border, color: Colors.yellow)
                    : (puan == 9)
                        ? Icon(Icons.star_half, color: Colors.yellow)
                        : Icon(Icons.star, color: Colors.yellow),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Flexible(child: Text('"$yorumMetni"')),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
