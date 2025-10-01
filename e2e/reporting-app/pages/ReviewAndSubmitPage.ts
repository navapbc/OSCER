import { Locator, Page } from '@playwright/test';
import { BasePage } from './BasePage';
import { DashboardPage } from './DashboardPage';

export class ReviewAndSubmitPage extends BasePage {
  get pagePath() {
    return '/activity_reports/review_and_submit';
  }

  readonly submitButton: Locator;

  constructor(page: Page) {
    super(page);
    this.submitButton = page.getByRole('button', { name: /Submit/i });
  }

  async clickSubmit() {
    await this.submitButton.click();
    return new DashboardPage(this.page).waitForURLtoMatchPagePath();
  }
}
