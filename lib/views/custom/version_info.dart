import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ShowVersionInfo extends StatelessWidget {
  const ShowVersionInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: _getPackageInfo(),
      initialData: PackageInfo(
        appName: '',
        packageName: '',
        version: '',
        buildNumber: '',
      ),
      builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'v${snapshot.data!.version}+${snapshot.data!.buildNumber}',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          );
        } else {
          return const Text('');
        }
      },
    );
  }
}

Future<PackageInfo> _getPackageInfo() async {
  PackageInfo _packageInfo = await PackageInfo.fromPlatform();
  return _packageInfo;
}
