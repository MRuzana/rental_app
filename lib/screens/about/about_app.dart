import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/screens/about/developer_information.dart';
import 'package:rental_app/screens/about/privacy_policy.dart';
import 'package:rental_app/screens/about/terms_and_conditions.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff8ECFCB),
        title: const Row(
          children: [
            Text(
              'About  ',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Rental App',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,                 
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Rental App',
                style: TextStyle(
                    color:Colors.black,
                    fontSize: 30,                    
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                '1.0.0',
                style: TextStyle(
                    color: Colors.black, fontSize: 12),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'About this app\n\n',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: 'Rental App',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              ' is a rental application that helps shop owners to manage their inventory effectively.\nWith ',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            height: 1.5,
                          ),
                        ),
                        const TextSpan(
                          text: 'Rental App',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              ', this owner can track products, orders, due orders, and revenue. The app provides a user-friendly interface and powerful features to assist owners in tracking products, and monitoring their profit over time. ',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            height: 1.5,
                          ),
                        ),
                        const TextSpan(
                          text: 'Rental App',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              ' will Replace all the paper works that the shop owner normally doing in his shop and easy to understand.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nDeveloper Information\n',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DeveloperInformation(),
                                ),
                              );
                            },
                        ),
                        TextSpan(
                          text: '\nPrivacy Policy\n',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PrivacyPolicy(),
                                ),
                              );
                            },
                        ),
                        TextSpan(
                          text: '\nTerms & Conditions\n',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TermsAndConditions(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
