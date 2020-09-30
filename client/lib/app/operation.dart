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
  getUserGames,
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

  // Purchase
  queryProductDetails,
  queryPastPurchases,
  buyQuestsAcceess,
}
