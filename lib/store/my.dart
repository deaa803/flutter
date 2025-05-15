import 'package:flutter/material.dart';
import 'package:vetlink1/store/profailinforow.dart';

class My extends StatelessWidget {
  const My({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:
      //// } else {
      // return
      Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 225,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assest/images/3.jpg'),
                    fit: BoxFit.fill,
                  ),
                  color: const Color.fromARGB(255, 254, 214, 129),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Positioned(
                top: 100,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        "assest/picture/logo vetlink crop2.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 80),
          Text(
            'naser',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileInfoRow(
                  icon: Icons.email,
                  title: 'Email',
                  value: 'pp@gmail.com',
                ),
                ProfileInfoRow(
                  icon: Icons.phone,
                  title: 'Phone',
                  value: '0936277282',
                ),
                ProfileInfoRow(
                  icon: Icons.location_on,
                  title: 'Location',
                  value: 'syr',
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: const Color.fromARGB(255, 254, 214, 129),
                  ),
                  child: Text('Edit Profile'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    side: BorderSide(
                      color: const Color.fromARGB(255, 254, 214, 129),
                    ),
                  ),
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 254, 214, 129),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
