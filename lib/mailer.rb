class Mailer < ActionMailer::Base
  def successful_post_validation(email, perk, pairs)
    @perk = perk
    @pairs = pairs

    mail(
      to: email,
      from: "jason@felloeyewear.com",
      subject: "Your #{perk} has been successfully submitted"
    ) do |format|
      format.text
      format.html
    end.deliver
  end
end
