import 'package:dva_dart/dva_dart.dart';
import 'package:pocket4d/services/p4d_http.dart';
import 'package:quickjs_dart/quickjs_dart.dart';

import 'state.dart';

DvaModel p4dAppModel = DvaModel(
    // namespace
    nameSpace: 'p4dApp',
    // initialState
    initialState: P4DAppState.init(),
    // reducers
    reducers: {
      'loadJson': (DvaState state, Payload<Map<String, dynamic>> payload) {
        return P4DAppState.loadJson(
            json: payload.payload["json"], indexPage: payload.payload["indexPage"]);
      },
    },
// effects
    effects: {
      'getBundle': (Payload<Map<String, String>> payload) async* {
        String bundleApiUrl = payload.payload["bundleApiUrl"];
        var result = await getBundle(url: bundleApiUrl);
        yield PutEffect(
            key: 'loadJson',
            payload: Payload<Map<String, dynamic>>({"json": result, "indexPage": result["indexKey"]}));
      },
      'requestAppList': (Payload<String> payload) async* {
        var result = await requestAppList(payload.payload);
        logger.i(result);
      },
    });
