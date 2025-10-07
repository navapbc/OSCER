class MembersController < StaffController
  def index
  end

  def show
    @member = Member.find(params[:id])
  end
end
