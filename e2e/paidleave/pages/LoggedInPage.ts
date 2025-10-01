import { Locator, Page } from '@playwright/test';
import { BasePage } from './BasePage';

export class LoggedInPage extends BasePage {
  private readonly menuButton: Locator;
  private readonly logOutLink: Locator;

  constructor(page: Page) {
    super(page);
    this.menuButton = this.page.getByRole('banner').getByText('Menu');
    this.logOutLink = this.page.getByText('Log out');
  }

  get pagePath(): string {
    return '/**';
  }

  private async expandMenu(): Promise<void> {
    if (await this.menuButton.isVisible()) {
      await this.menuButton.click();
    }
  }

  async isLoggedIn() {
    await this.expandMenu();
    return this.logOutLink.isVisible();
  }

  async logout() {
    await this.expandMenu();
    await this.logOutLink.click();
    await this.page.waitForURL('/');
  }
}
