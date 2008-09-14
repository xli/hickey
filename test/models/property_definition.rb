class PropertyDefinition < ActiveRecord::Base
  belongs_to :project
  should_bypass_all_callbacks_and_validations
end

class EnumPropertyDefinition < PropertyDefinition
  has_many :enum_values, :foreign_key => 'property_definition_id'
  should_bypass_all_callbacks_and_validations
end

class UserPropertyDefinition < PropertyDefinition
  should_bypass_all_callbacks_and_validations
end

class EnumValue < ActiveRecord::Base
  belongs_to :property_definition, :class_name => "EnumeratedPropertyDefinition", :foreign_key => "property_definition_id"
  should_bypass_all_callbacks_and_validations
end
