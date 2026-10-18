class CheckMailer < ApplicationMailer
  def report
    @check = params[:check]
    @repository = @check.repository

    mail(to: @repository.user.email, subject: t(".subject", repository: @repository.full_name))
  end
end
