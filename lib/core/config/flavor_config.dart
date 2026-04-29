class FlavorConfig {
  final String baseUrl;
  final String socketUrl;
  final String googleMapsApiKey;
  final String agoraAppId;
  final String stripePublishableKey;

  FlavorConfig._({
    required this.baseUrl,
    required this.socketUrl,
    required this.googleMapsApiKey,
    required this.agoraAppId,
    required this.stripePublishableKey,
  });

  static late FlavorConfig _instance;

  static FlavorConfig get instance => _instance;

  static void initialize({
    required String baseUrl,
    required String socketUrl,
    required String googleMapsApiKey,
    required String agoraAppId,
    required String stripePublishableKey,
  }) {
    _instance = FlavorConfig._(
      baseUrl: baseUrl,
      socketUrl: socketUrl,
      googleMapsApiKey: googleMapsApiKey,
      agoraAppId: agoraAppId,
      stripePublishableKey: stripePublishableKey,
    );
  }
}
