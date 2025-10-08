# frozen_string_literal: true

class MembersController < StaffController
  def index
    redirect_to search_members_path
  end

  def show
    @member, @certification_cases = Member.find_member_and_certification_cases_by_member_id(params[:id])
  end

  def search
    @members = Member.search_by_email(params[:email])
  end

  private

  def certification_service
    CertificationService.new
  end
end
