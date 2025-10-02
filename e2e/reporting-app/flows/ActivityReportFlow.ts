import { Page } from '@playwright/test';
import { SignInPage } from '../pages/users/SignInPage';

export class ActivityReportFlow {
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async run(email: string, password: string, employerName: string = 'Acme Inc', hours: string = '80') {
    const signInPage = await new SignInPage(this.page).go();
    const dashboardPage = await signInPage.signIn(email, password);
    const chooseMonthsPage = await dashboardPage.clickReportActivities();
    const activityReportPage = await chooseMonthsPage.selectFirstReportingPeriodAndSave();
    const activityDetailsPage = await activityReportPage.clickAddActivity();
    const supportingDocumentsPage = await activityDetailsPage.fillActivityDetails(employerName, hours);
    const activityReportPageAfterUpload = await supportingDocumentsPage.clickContinue();
    const reviewAndSubmitPage = await activityReportPageAfterUpload.clickReviewAndSubmit();
    const finalDashboardPage = await reviewAndSubmitPage.clickSubmit();

    return finalDashboardPage;
  }
}
