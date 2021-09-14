import 'package:flutter/material.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('John'),
        ),
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/sample_capture.png', height: 192, width: 192),
              SizedBox(
                height: 16,
              ),
              Text(
                'John Doe',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                'John Doe',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Ultratech Technology Pvt. Ltd.',
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                  child:
                      ElevatedButton(onPressed: () {}, child: Text('Sign Out')))
            ],
          ),
        ));
  }
}
