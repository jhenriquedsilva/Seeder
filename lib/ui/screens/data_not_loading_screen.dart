import 'package:flutter/material.dart';

class DataNotLoadingScreen extends StatelessWidget {
  const DataNotLoadingScreen({
    required void Function(void Function()) setStateCallback,
    required AsyncSnapshot snapshot,
  })  : _setStateCallback = setStateCallback,
        _snapshot = snapshot;

  final void Function(void Function()) _setStateCallback;
  final AsyncSnapshot _snapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Image.asset('assets/images/aegro-logo.png',
                    width: 200,
                    height: 200,
                    errorBuilder: (context, exception, stackTrace) {
                      return Text(
                        'Aegro',
                        style: Theme.of(context).textTheme.headline6,
                      );
                    },
                  ),
                ),
                Text(
                  _snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium,
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  onPressed: () {
                    _setStateCallback(() {});
                  },
                  child: Text(
                    'Recarregar',
                    style: Theme.of(context)
                        .textTheme
                        .button,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    padding: const EdgeInsets.all(16),
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.7, 60),
                    elevation: 16,
                    shadowColor: Colors.green,
                    shape: const StadiumBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
