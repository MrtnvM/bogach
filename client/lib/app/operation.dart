enum Operation {
  // Auth
  loginViaFacebook,
  loginViaGoogle,
  loginViaApple,

  // Profile
  loadCurrentUserProfile,
  sendDevicePushToken,
  updateUser,

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

  // Purchase
  queryProductDetails,
  queryPastPurchases,
  buyQuestsAcceess,
  buyMultiplayerGames,
}
