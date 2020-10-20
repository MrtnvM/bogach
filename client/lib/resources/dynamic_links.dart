class DynamicLinks {
  const DynamicLinks(this.customScheme) : baseUrl = 'https://$customScheme/';

  final String customScheme;
  final String baseUrl;

  static const join = 'join';
  static const roomInvite = 'roomInvite';
}
