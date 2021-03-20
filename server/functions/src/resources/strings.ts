export namespace Strings {
  export const debentures = () => get('debentures');
  export const realty = () => get('realty');
  export const business = () => get('business');
  export const currentPrice = () => get('currentPrice');
  export const mortgage = () => get('mortgage');
  export const businessCredit = () => get('businessCredit');
  export const battleInvitationNotificationTitle = () => get('battleInvitationNotificationTitle');
  export const battleInvitationNotificationBody = () => get('battleInvitationNotificationBody');

  export const newFriend = () => get('newFriend');
  export const friendRequestAccepted = () => get('friendRequestAccepted');
}

const strings: { [key: string]: string } = {
  currentPrice: 'Текущая цена: ',
  debentures: 'Облигации',
  stocks: 'Акции',
  realty: 'Недвижимость',
  business: 'Бизнес',
  mortgage: 'Ипотека',
  businessCredit: 'Бизнес-кредит',
  battleInvitationNotificationTitle: 'Вызываю тебя на дуэль!',
  battleInvitationNotificationBody: 'приглашает Вас сразиться в поединке капиталистов!',

  newFriend: 'Новый друг: ',
  friendRequestAccepted: 'Пользователь принял ваш запрос. Готовы вызвать его на поединок?',
};

const get = (key: string): string => strings[key];
