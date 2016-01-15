class SearchForm
  include Virtus.model
  include ActiveModel::Validations

  attribute :keyword, String
  attribute :price, String

  def error_fields
    errors.messages.keys.map(&:to_s).join(', ')
  end
end
