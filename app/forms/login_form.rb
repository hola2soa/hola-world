class LoginForm
  include Virtus.model
  include ActiveModel::Validations

  attribute :email_address, String
  validates :email_address, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  def error_fields
    errors.messages.keys.map(&:to_s).join(', ')
  end
end
