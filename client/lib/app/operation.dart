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
  addFriend,
  addFriendToStorage,

  // Purchase
  queryProductDetails,
  queryPastPurchases,
  buyQuestsAcceess,
  buyMultiplayerGames,
}
