import 'package:flutter/material.dart';
import 'package:randebul/Screens/ChatScreen.dart';
//import 'package:randebul/Screens/home_screen.dart';

class MusteriProfil extends StatefulWidget {
  final dynamic musteriRef;

  const MusteriProfil({Key? key, required this.musteriRef}) : super(key: key);
  @override
  State<MusteriProfil> createState() => _MusteriProfilState();
}

class _MusteriProfilState extends State<MusteriProfil> {
  final commentController = TextEditingController();
  final ratingController = TextEditingController();
  String firstname = "";
  String lastname = "";
  String mail = "";
  String phoneNumber = "";
  String address = "";
  String userName = "";
  String image = "";
  bool verified = false;
  String uid = "";
  Future<void> _getUserName() async {
    setState(() {
      firstname = '${widget.musteriRef['firstName']}';
      lastname = '${widget.musteriRef['surName']}';
      mail = '${widget.musteriRef['email']}';
      phoneNumber = '${widget.musteriRef['phoneNumber']}';
      address = '${widget.musteriRef['adress']}';
      userName = '${widget.musteriRef['userName']}';
      image = '${widget.musteriRef['imageURL']}';
      uid = '${widget.musteriRef['uid']}';
    });
  }

  @override
  Widget build(BuildContext context) {
    _getUserName();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Customer Profile'),
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
                  proffession: "",
                ),
                Container(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      child: const Icon(Icons.message),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                  messageRef: widget.musteriRef, id: uid))),
                    )),
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
  final String proffession;

  const UstKart({
    Key? key,
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
            ],
          ),
        ),
      ],
    );
  }
}

/*İletişim bilgileri kartlarının bulunduğu bölüm.*/
class IletisimBilgileri extends StatelessWidget {
  final String telNo;
  final String email;
  final String address;

  const IletisimBilgileri(
      {Key? key, this.telNo = '', this.email = '', this.address = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyCard(cardIcon: Icons.phone, cardText: telNo),
        MyCard(cardIcon: Icons.mail, cardText: email),
        MyCard(
          cardIcon: Icons.location_pin,
          cardText: address,
        ),
      ],
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
