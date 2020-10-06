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

  export const questsAccessProductId = id('bogach.quests.access');
  export const multiplayer1ProductId = id('bogach.multiplayer.1');
  export const multiplayer5ProductId = id('bogach.multiplayer.5');
  export const multiplayer10ProductId = id('bogach.multiplayer.10');
  
}
