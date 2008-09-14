class PropertyDefinition < ActiveRecord::Base
  belongs_to :project
end

class EnumPropertyDefinition < PropertyDefinition
  has_many :enum_values, :foreign_key => 'property_definition_id'
end

class UserPropertyDefinition < PropertyDefinition
end

class EnumValue < ActiveRecord::Base
  belongs_to :property_definition, :class_name => "EnumeratedPropertyDefinition", :foreign_key => "property_definition_id"
end
