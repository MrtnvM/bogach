class DynamicLinks {
  const DynamicLinks(this.customScheme) : baseUrl = 'https://$customScheme/app';

  final String customScheme;
  final String baseUrl;

  // params
  static const roomInvite = 'roomInvite';
  static const inviterId = 'inviterId';
}
