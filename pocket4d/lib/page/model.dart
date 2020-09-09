import 'package:dva_dart/dva_dart.dart';
import 'package:pocket4d/services/p4d_http.dart';

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
      'removeHandlerByPageId':(DvaState state, Payload<String> payload){
        return P4DAppState.removeHandlerById(payload.payload);
      }
    },
// effects
    effects: {
      'getBundle': (Payload<Map<String, String>> payload) async* {
        String bundleApiUrl = payload.payload["bundleApiUrl"];
        String indexKey = payload.payload["indexKey"];
        var result = await getBundle(url: bundleApiUrl);
        yield PutEffect(
            key: 'loadJson',
            payload: Payload<Map<String, dynamic>>({"json": result, "indexPage": indexKey}));
      },
      'removeHandler':(Payload<String> payload) async* {
        yield PutEffect(
            key: 'removeHandlerByPageId',
            payload: payload);
      },
    });
