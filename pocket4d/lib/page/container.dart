import 'package:dva_dart/dva_dart.dart' as Dva;
import 'package:dva_flutter/dva_flutter.dart';
import 'package:flutter/material.dart';

import 'page.dart';
import 'state.dart';

class DefaultLoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Loading",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

Widget p4dAppContainer(
    {BuildContext context, String bundleApiUrl}) {
  return DvaConnector(
    context: context,
    key: Key('P4DAppPage'),
    listenTo: ['p4dApp'],
    builder: (BuildContext context, DvaModels models, dispatch) {
      /// TODO: move all non-stateLess function to model, to make AppPage stateLess
      P4DAppState hybridAppState = models.getState('p4dApp');

      if (hybridAppState.status == P4DAppStatus.Loading &&
          bundleApiUrl.startsWith("http")) {
        dispatch(Dva.createAction('p4dApp/getBundle')(
            Dva.Payload<Map<String, String>>(
                {"bundleApiUrl": bundleApiUrl})));
      }

      // dispatch(Dva.createAction('dpoMiniApp/getBundle')(Dva.Payload(null)));
      if (hybridAppState.status == P4DAppStatus.Success) {
        return P4DPage(
            {},
            hybridAppState.pages,
            hybridAppState.handlers,
            hybridAppState.indexPage,
           );
      }

      return DefaultLoadingPage();
    },
  );
}
