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

  // Users
  addFriend,
  addFriendToStorage,
  removeFromFriends,

  // Purchase
  queryProductDetails,
  restorePurchases,
  buyQuestsAcceess,
  buyMultiplayerGames,
  buyWithNewYearAction,
}
