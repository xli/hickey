class Simple < ActiveRecord::Base
end

class Prisoner < ActiveRecord::Base
  set_table_name "users"
  
  def login=(login)
    raise 'unsupported operation'
  end
end

class SimpleObserver < ActiveRecord::Observer

  observe Simple
  def after_save(simple)
    raise 'should be bypass'
  end

  def after_create(simple)
    raise 'should be bypass'
  end

  def after_update(simple)
    raise 'should be bypass'
  end
end
