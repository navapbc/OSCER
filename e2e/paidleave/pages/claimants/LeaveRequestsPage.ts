import { Locator, Page } from '@playwright/test';
import { BasePage } from '../BasePage';
import { NewLeaveRequestPage } from './NewLeaveRequestPage';

export class LeaveRequestsPage extends BasePage {
  get pagePath() {
    return '/claimants/leave_requests';
  }

  readonly applyForLeaveButton: Locator;

  constructor(page: Page) {
    super(page);
    this.applyForLeaveButton = page.getByRole('link', { name: 'Apply for leave' });
  }

  async applyForLeave() {
    await this.applyForLeaveButton.click();
    return new NewLeaveRequestPage(this.page).waitForURLtoMatchPagePath();
  }
}
