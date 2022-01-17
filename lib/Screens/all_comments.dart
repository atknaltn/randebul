import 'package:flutter/material.dart';
import 'package:randebul/Screens/professional_profile.dart';

class AllCommentsPage extends StatefulWidget {
  final dynamic hocaRef;
  const AllCommentsPage({Key? key, required this.hocaRef}) : super(key: key);

  @override
  _AllCommentsPageState createState() => _AllCommentsPageState();
}

class _AllCommentsPageState extends State<AllCommentsPage> {
  dynamic yorumlar = <Map>[];
  int yorumSayisi = 0;
  @override
  Widget build(BuildContext context) {
    yorumlar = widget.hocaRef['comments'];
    yorumSayisi = yorumlar.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Comments'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey,
          ),
          child: ListView(
            children: [
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  'Last Comments to ${widget.hocaRef['name']} ${widget.hocaRef['surname']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (yorumlar == null || yorumlar.isEmpty)
                const Text('This professional haven\'t got any comments yet.')
              else
                for(int index = 1; index <= yorumSayisi; index++)
                    Column(
                      children: [
                        YorumKart(username: yorumlar[yorumSayisi - index]['username'],
                            tarih: yorumlar[yorumSayisi - index]['date'],
                            puan: yorumlar[yorumSayisi - index]['point'],
                            yorumMetni: yorumlar[yorumSayisi - index]['comment']),
                        const SizedBox(height: 10)
                      ],
                    ),
            ],
          ),
        ),
      ),

    );
  }
}
