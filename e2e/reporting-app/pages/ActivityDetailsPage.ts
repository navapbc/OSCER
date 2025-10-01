import { Locator, Page } from '@playwright/test';
import { BasePage } from './BasePage';
import { UploadSupportingDocumentationPage } from './UploadSupportingDocumentationPage';

export class ActivityDetailsPage extends BasePage {
  get pagePath() {
    return '/activity_reports/activity_details';
  }

  readonly employerNameField: Locator;
  readonly hoursField: Locator;
  readonly submitButton: Locator;

  constructor(page: Page) {
    super(page);
    this.employerNameField = page.getByLabel('Employer name');
    this.hoursField = page.getByLabel('Hours');
    this.submitButton = page.getByRole('button', { name: /Submit/i });
  }

  async fillActivityDetails(employerName: string, hours: string) {
    await this.employerNameField.fill(employerName);
    await this.hoursField.fill(hours);
    await this.submitButton.click();
    return new UploadSupportingDocumentationPage(this.page).waitForURLtoMatchPagePath();
  }
}
