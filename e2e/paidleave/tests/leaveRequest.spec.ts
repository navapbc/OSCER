import { expect } from '@playwright/test';
import { test } from '../../fixtures';
import { LeaveRequestFlow } from '../flows/LeaveRequestFlow';
import { LeaveRequestReviewFlow } from '../flows/LeaveRequestReviewFlow';
import { SignInPage } from '../pages/users/SignInPage';
import { LoggedInPage } from '../pages/LoggedInPage';

test('Leave request flow', async ({ page, claimantAccount, adminAccount }) => {
  const { email: claimantEmail, password: clamaintPassword } = claimantAccount;

  const { email: adminEmail, password: adminPassword } = adminAccount;

  const firstName = 'Alby';
  const middleName = '';
  const lastName = 'Testin';
  const ssn = '123456789';
  const ein = '987654321';
  const startDate = '10/01/2023';
  const endDate = '10/31/2023';
  const childDateOfBirth = '01/01/2020';
  const proofOfBirthFilePath = './test-data/birth-certificate.jpg';

  const leaveRequestFlow = new LeaveRequestFlow(page);
  const leaveRequestReviewFlow = new LeaveRequestReviewFlow(page);
  const signInPage = new SignInPage(page);

  const claimantMfaPreferencePage = await signInPage.signIn(claimantEmail, clamaintPassword);
  await claimantMfaPreferencePage.skipMFA();
  await leaveRequestFlow.run({
    firstName,
    middleName,
    lastName,
    ssn,
    ein,
    startDate,
    endDate,
    childDateOfBirth,
    proofOfBirthFilePath,
  });
  expect(page.getByRole('main')).toContainText('Leave request was successfully created');

  // Logout so we can log in as admin
  await new LoggedInPage(page).logout();

  await signInPage.go();
  const adminMfaPreferencePage = await signInPage.signIn(adminEmail, adminPassword);
  await adminMfaPreferencePage.skipMFA();
  leaveRequestReviewFlow.run({});
});
