import 'package:flutter/material.dart';
import 'package:myvcv/widget/widgets.dart';

class AboutUsPage extends StatefulWidget {
  static const String routeName = '/AboutUsPage';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => AboutUsPage(),
    );
  }

  const AboutUsPage({Key? key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
              child: SizedBox(
                  width: 100, child: Image.asset('assets/Logo_Name.png'))),
          Center(
              child: SizedBox(
                  width: 300, child: Image.asset('assets/aboutus.png'))),
          Text(
            'Welcome With Myvcv',
            style: TextStyle(fontSize: 20),
          ),
          ContinueWidget(),
        ],
      ),
    );
  }
}
