enum NetworkRequest {
  // Auth
  loginViaFacebook,
  loginViaGoogle,
  loginViaApple,

  // Profile
  loadCurrentUserProfile,
  sendUserPushToken,

  // Game
  loadGameTemplates,
  createGame,
  startNewMonth,
  getUserGames,
  getQuests,
  createQuestGame,

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
