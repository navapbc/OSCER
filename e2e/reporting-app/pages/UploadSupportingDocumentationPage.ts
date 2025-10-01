import { Locator, Page } from '@playwright/test';
import { BasePage } from './BasePage';
import { ReportActivitiesPage } from './ReportActivitiesPage';

export class UploadSupportingDocumentationPage extends BasePage {
  get pagePath() {
    return '/activity_reports/upload_supporting_documentation';
  }

  readonly continueButton: Locator;

  constructor(page: Page) {
    super(page);
    this.continueButton = page.getByRole('button', { name: /Continue/i });
  }

  async clickContinue() {
    await this.continueButton.click();
    return new ReportActivitiesPage(this.page).waitForURLtoMatchPagePath();
  }
}
