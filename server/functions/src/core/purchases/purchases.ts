// import { SHA256 } from 'crypto-ts';
import * as SHA256 from 'sha256';

export namespace Purchases {
  export const id = (productId: string) => {
    const salt = '(c) Bogach Team';
    const string = productId + salt;

    const hash1 = SHA256(string);
    const hash2 = SHA256(hash1);
    const hash3 = SHA256(hash2);

    return hash3;
  };

  export const questsAccessProductId = 'bogach.quests.access';

  export const newYear2022ActionProductId = 'bogach.new_year_2022';

  export const depricatedMultiplayer1ProductId = 'bogach.multiplayer.1';
  export const depricatedMultiplayer5ProductId = 'bogach.multiplayer.5';
  export const depricatedMultiplayer10ProductId = 'bogach.multiplayer.10';

  export const multiplayerGames1 = 'bogach.multiplayer.games.1';
  export const multiplayerGames10 = 'bogach.multiplayer.games.10';
  export const multiplayerGames25 = 'bogach.multiplayer.games.25';
}
