class PropertyDefinition < ActiveRecord::Base
  belongs_to :project
end

class EnumPropertyDefinition < PropertyDefinition
end

class UserPropertyDefinition < PropertyDefinition
end
