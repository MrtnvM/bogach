class DynamicLinks {
  const DynamicLinks(this.customScheme) : baseUrl = 'https://$customScheme/';

  final String customScheme;
  final String baseUrl;

  // route
  static const join = 'join';

  static const addFriend = 'addFriend';

  // params
  static const roomInvite = 'roomInvite';
  static const inviterId = 'inviterId';
}
