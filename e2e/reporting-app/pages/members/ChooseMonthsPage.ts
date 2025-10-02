import { Locator, Page } from '@playwright/test';
import { BasePage } from '../BasePage';
import { ActivityReportPage } from './ActivityReportPage';

export class ChooseMonthsPage extends BasePage {
  get pagePath() {
    return '/activity_report_application_forms/new';
  }

  readonly reportingPeriodDropdown: Locator;
  readonly saveButton: Locator;

  constructor(page: Page) {
    super(page);
    this.reportingPeriodDropdown = page.getByLabel('Reporting period');
    this.saveButton = page.getByRole('button', { name: /Save/i });
  }

  async selectFirstReportingPeriodAndSave() {
    await this.reportingPeriodDropdown.selectOption({ index: 1 });
    await this.saveButton.click();
    return new ActivityReportPage(this.page).waitForURLtoMatchPagePath();
  }
}
