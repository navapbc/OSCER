import { Locator, Page } from '@playwright/test';
import { BasePage } from '../BasePage';
import { LeaveRequestPage } from './LeaveRequestPage';

export class NewLeaveRequestPage extends BasePage {
  get pagePath() {
    return '/claimants/leave_requests/new';
  }

  readonly firstNameInput: Locator;
  readonly middleNameInput: Locator;
  readonly lastNameInput: Locator;
  readonly ssnInput: Locator;
  readonly einInput: Locator;
  readonly leaveStartDateInput: Locator;
  readonly leaveEndDateInput: Locator;
  readonly childDateOfBirthInput: Locator;
  readonly proofOfBirthInput: Locator;
  readonly submitButton: Locator;

  constructor(page: Page) {
    super(page);

    this.firstNameInput = this.page.getByLabel('First name');
    this.middleNameInput = this.page.getByLabel('Middle name');
    this.lastNameInput = this.page.getByLabel('Last name');
    this.ssnInput = this.page.getByLabel('Social security number');
    this.einInput = this.page.getByLabel('Employer identification number');
    this.leaveStartDateInput = this.page.getByLabel('Start date');
    this.leaveEndDateInput = this.page.getByLabel('End date');
    this.childDateOfBirthInput = this.page.getByLabel('Child’s date of birth');
    this.proofOfBirthInput = this.page.getByLabel('File');
    this.submitButton = this.page.getByRole('button', { name: 'Submit' });
  }

  async fillPersonalInfo(firstName: string, middleName: string, lastName: string, ssn: string) {
    await this.firstNameInput.fill(firstName);
    await this.middleNameInput.fill(middleName);
    await this.lastNameInput.fill(lastName);
    await this.ssnInput.fill(ssn);
  }

  async fillEmploymentInfo(ein: string) {
    await this.einInput.fill(ein);
  }

  async fillLeaveInfo(startDate: string, endDate: string, childDateOfBirth: string) {
    await this.leaveStartDateInput.fill(startDate);
    await this.leaveEndDateInput.fill(endDate);
    await this.childDateOfBirthInput.fill(childDateOfBirth);
  }

  async uploadProof(filePath: string) {
    await this.proofOfBirthInput.setInputFiles(filePath);
  }

  async submit() {
    await this.submitButton.click();
    return new LeaveRequestPage(this.page).waitForURLtoMatchPagePath();
  }
}
