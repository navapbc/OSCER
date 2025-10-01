import { Page } from '@playwright/test';
import { AdminPage } from '../pages/admin/AdminPage';

interface RunParams {}

export class LeaveRequestReviewFlow {
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async run(params: RunParams) {
    const {} = params;

    const adminPage = await new AdminPage(this.page).go();
  }
}
