import { Locator, Page } from '@playwright/test';
import { BasePage } from './BasePage';
import { SignInPage } from './SignInPage';

export class VerifyAccountPage extends BasePage {
  get pagePath() {
    return '/users/verify-account';
  }

  readonly verificationCodeField: Locator;
  readonly submitButton: Locator;

  constructor(page: Page) {
    super(page);
    this.verificationCodeField = page.getByLabel('Verification code');
    this.submitButton = page.getByRole('button', { name: /Verify/i });
  }

  async submitVerificationCode(emailAddress: string, verificationCode: string) {
    await this.verificationCodeField.fill(verificationCode);
    await this.submitButton.click();
    return new SignInPage(this.page).waitForURLtoMatchPagePath();
  }
}
