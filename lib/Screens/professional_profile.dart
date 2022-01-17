import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'all_comments.dart';
import 'appointment_screen.dart';
import 'package:intl/intl.dart';
import 'package:randebul/Screens/ChatScreen.dart';
//import 'package:randebul/Screens/home_screen.dart';

class ProfessionalProfile extends StatefulWidget {
  final dynamic hocaRef;
  final DocumentSnapshot hocaSnapshot;

  const ProfessionalProfile(
      {Key? key, required this.hocaRef, required this.hocaSnapshot})
      : super(key: key);
  @override
  State<ProfessionalProfile> createState() => _ProfessionalProfileState();
}

class _ProfessionalProfileState extends State<ProfessionalProfile> {
  final commentController = TextEditingController();
  final ratingController = TextEditingController();
  String firstname = "";
  String lastname = "";
  String mail = "";
  String phoneNumber = "";
  String address = "";
  String userName = "";
  String website = "";
  String hakkinda = "";
  String profession = "";
  String image = "";
  double puan = 0;
  bool verified = false;
  Future<void> _getUserName() async {
    setState(() {
      firstname = '${widget.hocaRef['name']}';
      lastname = '${widget.hocaRef['surname']}';
      mail = '${widget.hocaRef['mail']}';
      phoneNumber = '${widget.hocaRef['phonenumber']}';
      address = '${widget.hocaRef['adress']}';
      userName = '${widget.hocaRef['username']}';
      website = '${widget.hocaRef['website']}';
      image = '${widget.hocaRef['imageURL']}';
      hakkinda = '${widget.hocaRef['about']}';
      verified = widget.hocaRef['verified'];
      profession = '${widget.hocaRef['profession']}';
      if(widget.hocaRef['comments'] != null){
        puan = widget.hocaRef['point'] / widget.hocaRef['comments'].length;
      }
      else{
        puan = -1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _getUserName();
    final comment = TextFormField(
      autofocus: false,
      controller: commentController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        commentController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Write your comment",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final rating = TextFormField(
      autofocus: false,
      controller: ratingController,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        if (value != null) {
              commentController.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.star),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Write your rating",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    Future<void> updateFireBase() async {
      CollectionReference temp1 =
          FirebaseFirestore.instance.collection('users');
      DocumentReference temp2 =
          temp1.doc((FirebaseAuth.instance.currentUser)!.uid);
      var response = await temp2.get();
      dynamic veri = response.data();

      bool validComment = int.parse(ratingController.text) <= 10 && int.parse(ratingController.text) >= 0 && commentController.text.isNotEmpty && ratingController.text.isNotEmpty;

      if (validComment) {
        FirebaseFirestore.instance
            .collection('professionals')
            .doc(widget.hocaSnapshot.id)
            .update({
          'point': FieldValue.increment(int.parse(ratingController.text)),
          'comments': FieldValue.arrayUnion([
            {
              'username': veri['userName'],
              'point': int.parse(ratingController.text),
              'date': DateFormat('dd.MM.y').format(DateTime.now()),
              'comment': commentController.text,
            }
          ])
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const SizedBox(
                height: 80,
                child: Text('Comment was made successfully.'),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Return'))
              ],
            );
          },
        );
      }
      else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Failed'),
              content: const SizedBox(
                height: 80,
                child: Text('Please enter a valid comment and rating.'),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Return'))
              ],
            );
          },
        );
      }

    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Professional Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: ListView(
              children: [
                UstKart(
                  puan: puan.toDouble(),
                  resimAdresi: image,
                  verified: verified,
                  isim: firstname + " " + lastname,
                  username: userName,
                  proffession: profession,
                ),
                Container(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      child: const Icon(Icons.message),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(messageRef: widget.hocaRef))),
                    )),
                const SizedBox(height: 30),
                Hakkinda(hakkindaYazisi: hakkinda),
                const SizedBox(height: 30),
                IletisimBilgileri(
                  telNo: phoneNumber,
                  email: mail,
                  website: website,
                  address: address,
                ),
                const SizedBox(height: 30),
                Yorumlar(
                  hocaRef: widget.hocaRef,
                ),
                const SizedBox(height: 30),
                comment,
                rating,
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
                      updateFireBase();
                    },
                    child:
                        const IconText(icon: Icons.comment, text: 'Make Comment'),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: GestureDetector(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppointmentScreen(
                                    hocaRef: widget.hocaRef,
                                    hocaSnapshot: widget.hocaSnapshot)));
                      },
                      child: const IconText(
                          icon: Icons.calendar_today, text: 'Get Appointment')),
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
  final double puan;
  final bool verified;
  final String resimAdresi;
  final String isim;
  final String username;
  final String proffession;

  const UstKart({
    Key? key,
    this.puan = 5,
    this.verified = false,
    this.resimAdresi = 'assets/blankprofile.png',
    this.isim = '',
    this.username = '',
    this.proffession = '',
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
              Text(proffession),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (puan != -1)
                  ? Text('Rating: ${puan.toStringAsFixed(1)} ')
                  : const Text('Rating: N/A'),
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
                      builder: (context) =>
                          AllCommentsPage(hocaRef: hocaRef))),
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
