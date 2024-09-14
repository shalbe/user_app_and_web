import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

void launchURL(url) async => await canLaunch(url)
    ? await launch(url)
    : Fluttertoast.showToast(msg: 'Could not launch $url');
