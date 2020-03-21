import { FirestoreSelector } from './firestore_selector';
import { GameEntity } from '../models/domain/game/game';
import { UserId } from '../models/domain/user';
import { Firestore } from '../core/firebase/firestore';
import { Account, AccountEntity } from '../models/domain/account';

export class AccountProvider {
  constructor(
    private firestore: Firestore,
    private selector: FirestoreSelector,
    private gameId: GameEntity.Id
  ) {}

  async getAccount(userId: UserId): Promise<Account> {
    const selector = this.selector.account(this.gameId, userId);
    let account: Account = (await this.firestore.getItem(selector)).data() as Account;

    if (!account) {
      account = { cashFlow: 0, balance: 0, credit: 0 };
    }

    AccountEntity.validate(account);

    return account;
  }

  async updateAccount(userId: UserId, account: Account): Promise<Account> {
    const assetId = account.id;
    if (!assetId) {
      throw 'ERROR: Account Provider - no asset ID on updating';
    }

    AccountEntity.validate(account);
    const selector = this.selector.account(this.gameId, userId);
    let updatedAccount: Account;

    if ((await selector.get()).exists) {
      updatedAccount = await this.firestore.updateItem(selector, account);
    } else {
      updatedAccount = await this.firestore.createItem(selector, account, { createdAt: false });
    }

    AccountEntity.validate(updatedAccount);
    return updatedAccount as Account;
  }
}
