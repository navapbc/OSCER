class MembersController < StaffController
  def index
    redirect_to search_members_path
  end

  def show
    @certification_cases = certification_service.find_cases_by_member_id(params[:id])
    @member = Member.new(member_id: params[:id], email: @certification_cases.first.certification.member_email)
  end

  def search
    @members = []
    Certification.find_by_member_email(params[:email]).each do |certification|
      @members << Member.new(member_id: certification.member_id, email: certification.member_email)
    end
  end

  private

  def certification_service
    CertificationService.new
  end
end
