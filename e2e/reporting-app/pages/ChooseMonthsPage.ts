import { Locator, Page } from '@playwright/test';
import { BasePage } from './BasePage';
import { ReportActivitiesPage } from './ReportActivitiesPage';

export class ChooseMonthsPage extends BasePage {
  get pagePath() {
    return '/activity_reports/choose_months';
  }

  readonly reportingPeriodDropdown: Locator;
  readonly saveButton: Locator;

  constructor(page: Page) {
    super(page);
    this.reportingPeriodDropdown = page.getByLabel('Reporting period');
    this.saveButton = page.getByRole('button', { name: /Save/i });
  }

  async selectFirstReportingPeriodAndSave() {
    await this.reportingPeriodDropdown.selectOption({ index: 0 });
    await this.saveButton.click();
    return new ReportActivitiesPage(this.page).waitForURLtoMatchPagePath();
  }
}
