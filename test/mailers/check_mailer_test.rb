require "test_helper"

class CheckMailerTest < ActionMailer::TestCase
  test "#report" do
    check = repository_checks(:finished)
    email = CheckMailer.with(check: check).report

    assert_emails 1 do
      email.deliver_now
    end

    assert { email.to == [ check.repository.user.email ] }
    assert { email.subject.include?(check.repository.full_name) }
  end
end
