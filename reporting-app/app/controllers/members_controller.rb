class MembersController < StaffController
  def index
    redirect_to search_members_path
  end

  def show
    @certification = Certification.find_by_member_id(params[:id])
  end

  def search
    @members = []
    Certification.find_by_member_email(params[:email]).each do |certification|
      @members << Member.new(member_id: certification.member_id, email: certification.member_email)
    end
  end
end
