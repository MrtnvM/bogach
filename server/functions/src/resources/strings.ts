export namespace Strings {
  export const debetures = () => get('debetures');
  export const realty = () => get('realty');
  export const currentPrice = () => get('currentPrice');
  export const battleInvitationNotificationTitle = () => get('battleInvitationNotificationTitle');
  export const battleInvitationNotificationBody = () => get('battleInvitationNotificationBody');
}

const strings: { [key: string]: string } = {
  debetures: 'Облигации',
  stocks: 'Акции',
  realty: 'Недвижимость',
  battleInvitationNotificationTitle: 'Вызываю тебя на дуэль!',
  battleInvitationNotificationBody: 'приглашает Вас сразиться в поединке капиталистов!',
};

const get = (key: string): string => strings[key];
