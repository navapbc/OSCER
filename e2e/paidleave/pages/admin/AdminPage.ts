import { Page } from '@playwright/test';
import { BasePage } from '../BasePage';

export class AdminPage extends BasePage {
  get pagePath() {
    return '/admin/**';
  }

  constructor(page: Page) {
    super(page);
  }
}
