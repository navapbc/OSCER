import { expect } from '@playwright/test';

import { test } from '../../fixtures';
import { AccountCreationFlow } from '../flows/AccountCreationFlow';
import { LoggedInPage } from '../pages/LoggedInPage';

test('Claimant account creation flow', async ({ page, emailService }) => {
  // Triple the default timeout for this test due
  // to external email verification code dependency
  test.slow();

  const email = emailService.generateEmailAddress(emailService.generateUsername());
  const password = 'testPassword';

  const accountCreationFlow = new AccountCreationFlow(page, emailService);
  const signInPage = await accountCreationFlow.run(email, password);

  // Verify that we can log in
  await signInPage.signIn(email, password);

  // Verify that we are logged in
  const loggedInPage = new LoggedInPage(page);
  expect(await loggedInPage.isLoggedIn()).toBe(true);
});
