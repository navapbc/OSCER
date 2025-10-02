import { Locator, Page } from '@playwright/test';
import { BasePage } from './BasePage';
import { ReportActivitiesPage } from './ReportActivitiesPage';

export class SupportingDocumentsPage extends BasePage {
  get pagePath() {
    return 'activity_report_application_forms/*/activities/*/documents';
  }

  readonly continueButton: Locator;

  constructor(page: Page) {
    super(page);
    this.continueButton = page.getByRole('link', { name: /continue/i });
  }

  async clickContinue() {
    await this.continueButton.click();
    return new ReportActivitiesPage(this.page).waitForURLtoMatchPagePath();
  }
}
