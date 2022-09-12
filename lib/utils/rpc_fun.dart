import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:near_hola_match_flutter/models/name_and_language.dart';

const Map<String, String> headers = {
  'Content-type': 'application/json; charset=utf-8'
};

const String rpcUrlTestnet = 'https://rpc.testnet.near.org';
const String contractId = 'contrato1.jeph.testnet';
const String methodName = 'hello_name';

final Random rng = Random();

Future<String> callFetch({required NameAndLanguage nameAndLanguage}) async {
  final String returned = await compute(fetchRpc, nameAndLanguage);
  print('returned: $returned');
  return returned;
}

Future<String> fetchRpc(
  NameAndLanguage nameAndLanguage,
) async {
  final url = Uri.parse(rpcUrlTestnet);
  final Map<String, String> args = {
    "name": nameAndLanguage.name,
    "language": nameAndLanguage.language
  };
  var argsBase64 = base64.encode(utf8.encode(json.encode(args)));
  final body = json.encode(httpBody(
    methodName: methodName,
    contractId: contractId,
    argsBase64: argsBase64,
  ));
  final http.Response response = await http.post(
    url,
    headers: headers,
    body: body,
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseJson = json.decode(response.body);
    final resultParsed = decodeBuffer(buffer: responseJson['result']['result']);
    return resultParsed;
  } else {
    throw Exception('Failed to load post');
  }
}

String decodeBuffer({required List<dynamic> buffer}) {
  final List<int> bufferInt = buffer
      .map((e) => int.parse(e.toString().replaceAll(RegExp(r"\s"), "")))
      .toList();
  try {
    final bufferDecoded = utf8.decode(bufferInt);
    return bufferDecoded;
  } catch (e) {
    return 'Error decoding buffer';
  }
}

Map<String, Object> httpBody(
    {required String methodName,
    required String contractId,
    required String argsBase64,
    String finality = "final"}) {
  return {
    'jsonrpc': "2.0",
    'method': "query",
    "id": rng.nextInt(10000),
    'params': {
      "request_type": "call_function",
      "account_id": contractId,
      "method_name": methodName,
      "args_base64": argsBase64,
      "finality": finality
    },
  };
}
