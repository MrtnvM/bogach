enum Operation {
  // Auth
  loginViaFacebook,
  loginViaGoogle,
  loginViaApple,

  // Profile
  loadCurrentUserProfile,
  sendDevicePushToken,

  // Game
  loadGameTemplates,
  createGame,
  startNewMonth,
  getQuests,
  createQuestGame,
  sendPlayerAction,

  // Multiplayer
  createRoom,
  createRoomGame,
  joinRoom,
  queryUserProfiles,
  setRoomParticipantReady,
  shareRoomInviteLink,
  setOnline,
  addFriend,

  // Purchase
  queryProductDetails,
  queryPastPurchases,
  buyQuestsAcceess,
  buyMultiplayerGames,
}
