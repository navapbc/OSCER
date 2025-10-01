import { Locator, Page } from '@playwright/test';
import { BasePage } from '../BasePage';

export class LeaveRequestPage extends BasePage {
  get pagePath() {
    return '/leave_requests/*';
  }

  constructor(page: Page) {
    super(page);
  }
}
