import { Locator, Page } from '@playwright/test';
import { BasePage } from './BasePage';

export class CertificationRequestPage extends BasePage {
  get pagePath() {
    return '/demo/certifications/new';
  }

  readonly emailField: Locator;
  readonly requestCertificationButton: Locator;

  constructor(page: Page) {
    super(page);
    this.emailField = page.getByLabel('Email');
    this.requestCertificationButton = page.getByRole('button', { name: /Request certification/i });
  }

  async fillEmailAndSubmit(email: string) {
    await this.emailField.fill(email);
    await this.requestCertificationButton.click();
  }
}
