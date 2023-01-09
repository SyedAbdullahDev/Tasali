import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeveloperAbout extends StatefulWidget {
  const DeveloperAbout({Key? key}) : super(key: key);

  @override
  State<DeveloperAbout> createState() => _DeveloperAboutState();
}

class _DeveloperAboutState extends State<DeveloperAbout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Developers'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 9,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'tasali LLC',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                    child: Text(
                      'This App Is Developed By tasali LLC',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Hello there,we are a Web & App Developing Company who has strong knowledge in Web & App Development Specially in E-Commerce Field. Professionally Working in relevant fields for the last 4 years. Our passion is to create beautiful mobile-friendly Websites & Apps.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.mail,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'support@tasali.app',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
