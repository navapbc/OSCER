import { Locator, Page } from '@playwright/test';
import { BasePage } from './BasePage';
import { ActivityDetailsPage } from './ActivityDetailsPage';
import { ReviewAndSubmitPage } from './ReviewAndSubmitPage';

export class ReportActivitiesPage extends BasePage {
  get pagePath() {
    return '/activity_reports';
  }

  readonly addActivityButton: Locator;
  readonly reviewAndSubmitButton: Locator;

  constructor(page: Page) {
    super(page);
    this.addActivityButton = page.getByRole('button', { name: /add activity/i });
    this.reviewAndSubmitButton = page.getByRole('button', { name: /review and submit/i });
  }

  async clickAddActivity() {
    await this.addActivityButton.click();
    return new ActivityDetailsPage(this.page).waitForURLtoMatchPagePath();
  }

  async clickReviewAndSubmit() {
    await this.reviewAndSubmitButton.click();
    return new ReviewAndSubmitPage(this.page).waitForURLtoMatchPagePath();
  }
}
