import { Page } from '@playwright/test';
import { LeaveRequestsPage } from '../pages/claimants/LeaveRequestsPage';

interface RunParams {
  firstName: string;
  lastName: string;
  middleName: string;
  ssn: string;
  ein: string;
  startDate: string;
  endDate: string;
  childDateOfBirth: string;
  proofOfBirthFilePath: string;
}

export class LeaveRequestFlow {
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async run(params: RunParams) {
    const {
      firstName,
      middleName,
      lastName,
      ssn,
      ein,
      startDate,
      endDate,
      childDateOfBirth,
      proofOfBirthFilePath,
    } = params;

    const leaveRequestsPage = await new LeaveRequestsPage(this.page).go();
    const newLeaveRequestPage = await leaveRequestsPage.applyForLeave();

    await newLeaveRequestPage.fillPersonalInfo(firstName, middleName, lastName, ssn);
    await newLeaveRequestPage.fillEmploymentInfo(ein);
    await newLeaveRequestPage.fillLeaveInfo(startDate, endDate, childDateOfBirth);
    await newLeaveRequestPage.uploadProof(proofOfBirthFilePath);
    return await newLeaveRequestPage.submit();
  }
}
