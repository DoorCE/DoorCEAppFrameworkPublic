import 'package:universal_html/html.dart' as html;
import 'package:logging/logging.dart';

abstract interface class AbstractMessageHandler {
  Future<Map<String, dynamic>> getMessageFromPlatform();
}

class MessageHandler implements AbstractMessageHandler {
  final String readyFromAppType;
  final String readyFromPlatformType;
  final String platformUrl;
  final _log = Logger("message_handler");

  MessageHandler(this.platformUrl, {this.readyFromAppType = 'READY_FROM_APP', this.readyFromPlatformType = 'READY_FROM_PLATFORM'});

  @override
  Future<Map<String, dynamic>> getMessageFromPlatform() async {
    try {
      final expectedOrigin = Uri.parse(platformUrl).origin;

      _log.info("[getMessageFromPlatform] Posting message '$readyFromAppType' to platform origin: $expectedOrigin");
      html.window.parent?.postMessage(
        {'type': readyFromAppType},
        expectedOrigin
      );

      _log.info("[getMessageFromPlatform] Waiting for message (type: $readyFromPlatformType) from platform...");
      // Listen for messages from parent
      var message = await html.window.onMessage.firstWhere((event) => event.origin == expectedOrigin 
        && event.data['type'] == readyFromPlatformType,
        orElse: () => throw Exception('No valid message received from platform')
      );

      if (message.data is Map) {
        final dataMap = Map<String, dynamic>.from(message.data);

        _log.fine("[getMessageFromPlatform] Received message from platform: $dataMap");
        return dataMap;
      } else {
        throw Exception('Unexpected message format: ${message.data.runtimeType}');
      }
    } catch (e, st) {
      _log.severe("[getMessageFromPlatform] Operation failed: $e\n$st");
      rethrow;
    }
    //listen((event) {
    //  if (event.origin != platformUrl) return;

    //  final data = event.data;
     // print('Iframe received: $data');

    //  if (data is Map && data['type'] == typeFromMain) {
     ///   return Map<String, String>.from(data);
    //  } else {
     //   print('Unexpected message format or type');
    //  }
    //});

  }
}