import { expect } from '@playwright/test';

import { test } from '../../fixtures';
import { AccountCreationFlow } from '../flows';
import {
  CertificationRequestPage,
  SignInPage,
  DashboardPage,
  ChooseMonthsPage,
  ReportActivitiesPage,
  ActivityDetailsPage,
  UploadSupportingDocumentationPage,
  ReviewAndSubmitPage,
  StaffDashboardPage
} from '../pages';

test('Certification request and activity report flow', async ({ page, emailService }) => {
  // Triple the default timeout for this test due
  // to external email verification code dependency
  test.slow();

  const email = emailService.generateEmailAddress(emailService.generateUsername());
  const password = 'testPassword';

  // Step 1: Start at /demo/certifications/new and fill in email
  const certificationRequestPage = await new CertificationRequestPage(page).go();
  await certificationRequestPage.fillEmailAndSubmit(email);

  // Step 2: Create account with the email address
  const accountCreationFlow = new AccountCreationFlow(page, emailService);
  const signInPage = await accountCreationFlow.run(email, password);

  // Step 3: Log in to get to the dashboard page
  const dashboardPage = await signInPage.signIn(email, password);

  // Step 4: Click on "report activities" to get to the "choose months" page
  const chooseMonthsPage = await dashboardPage.clickReportActivities();

  // Step 5: Select the first option from the "reporting period" dropdown and click "save"
  const reportActivitiesPage = await chooseMonthsPage.selectFirstReportingPeriodAndSave();

  // Step 6: Click on "add activity" to go to the "activity details" page
  const activityDetailsPage = await reportActivitiesPage.clickAddActivity();

  // Step 7: Fill in "Acme Inc" for "employer name" field and "80" for the "hours" field and submit
  const uploadSupportingDocumentationPage = await activityDetailsPage.fillActivityDetails('Acme Inc', '80');

  // Step 8: Click "continue" to go back to the "report activities" page
  const reportActivitiesPageAfterUpload = await uploadSupportingDocumentationPage.clickContinue();

  // Step 9: Click "review and submit" to go to the "review and submit" page
  const reviewAndSubmitPage = await reportActivitiesPageAfterUpload.clickReviewAndSubmit();

  // Step 10: Click "submit" to go back to the "dashboard page"
  const finalDashboardPage = await reviewAndSubmitPage.clickSubmit();

  // Step 11: Navigate to /staff to go to the "staff dashboard"
  const staffDashboardPage = await new StaffDashboardPage(page).go();

  // Verify we're on the staff dashboard
  expect(page.url()).toContain('/staff');
});
