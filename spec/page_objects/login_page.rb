class LoginPage
  include PageObject

  text_field(:email_address, :id => 'email_address')
  button(:login, :id => 'login')
  
  def login_with(email_address)
    self.email_address = email_address
    login
  end
end
