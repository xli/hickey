class Simple < ActiveRecord::Base
end

class Prisoner < ActiveRecord::Base
  set_table_name "users"
  
  def login=(login)
    raise 'unsupported operation'
  end
end