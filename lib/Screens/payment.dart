import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:randebul/Screens/credit_card.dart';
import 'constants.dart';

class Payment extends StatefulWidget {
  // This widget is the root of your application.
  Payment({Key? key}) : super(key: key);
  MyHomePage createState() => MyHomePage();
}

class MyHomePage extends State<Payment> {
  String firstname = "";
  String lastname = "";
  String amount = "";
  Future<void> _getUserName() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc((await FirebaseAuth.instance.currentUser)!.uid)
        .get()
        .then((value) {
      setState(() {
        firstname = value.data()!['firstName'].toString();
        lastname = value.data()!['surName'].toString();
        amount = value.data()!['amount'].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _getUserName();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.redAccent,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 64),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  _buildHeader(firstname + " " + lastname),
                  SizedBox(height: 16),
                  _buildGradientBalanceCard(amount),
                  SizedBox(height: 24.0),
                  _buildCategories(),
                ],
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Row _buildCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildCategoryCard(
            bgColor: Constants.paymentBackgroundColor,
            iconColor: Constants.paymentIconColor,
            iconData: Icons.payment,
            text: "Add Fund",
            num: 1),
      ],
    );
  }

  Container _buildGradientBalanceCard(String amount) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purpleAccent.withOpacity(0.9),
            Constants.deepBlue,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "\$" + amount,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 28,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Total Balance",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildHeader(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Hello,",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ],
    );
  }

  Row _buildTransactionItem(
      {required Color color,
      required IconData iconData,
      required String date,
      required String title,
      required double amount}) {
    return Row(
      children: <Widget>[
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              date,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            )
          ],
        ),
        Spacer(),
        Text(
          "-\$ $amount",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Column _buildCategoryCard(
      {required Color bgColor,
      required Color iconColor,
      required IconData iconData,
      required String text,
      required int num}) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (num == 1)
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CreditCard(amount)),
              );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120.0),
            child: Container(
              height: 90,
              width: 110,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                iconData,
                color: iconColor,
                size: 36,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(text),
      ],
    );
  }
}
