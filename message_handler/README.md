# doorce_message_handler

Message handler for iframe <-> parent window communication.

Provides:
- `MessageHandler`
- `IFrameTexts` constants
- `XIFrameMessage` for parsing incoming messages.

## Usage

```dart
MessageHandler messageHandler = MessageHandler(const String.fromEnvironment("PARENT_URL", defaultValue: "http://localhost:60100"),
      readyFromAppType: IFrameTexts.readyFromApp,
      readyFromPlatformType: IFrameTexts.readyFromPlatform
    );
 
Map<String, dynamic> messageMap = await messageHandler.getMessageFromPlatform();
XIFrameMessage message = XIFrameMessage.fromJson(messageMap);
```