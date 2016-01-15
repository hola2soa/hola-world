# String attribute for form objects of TutorialForm
class StringStripped < Virtus::Attribute
  def coerce(value)
    value.is_a?(String) ? value.strip : nil
  end
end

# Array<String> attribute for form objects of QueenshopForm
class ArrayOfNames < Virtus::Attribute
  def coerce(value)
    value.is_a?(String) ?
      value.split("\r\n").map(&:strip).reject(&:empty?) : nil
  end
end

class ArrayOfPrices < Virtus::Attribute
  def coerce(value)
    # should review this validation to integer
    # error out as is not correctly checking
    value.is_a?(String) ?
      value.split("\r\n").map(&:strip).reject(&:empty?).map(&:to_i) : nil
  end
end

##
# Form object
class QueenshopForm
  include Virtus.model
  include ActiveModel::Validations

  attribute :items, ArrayOfNames
  attribute :prices, ArrayOfPrices
  attribute :pages, String, :default => '1..9'

  validates :items, presence: true
  validates :prices, presence: true
  validates :pages, presence: false

  def error_fields
    errors.messages.keys.map(&:to_s).join(', ')
  end
end
