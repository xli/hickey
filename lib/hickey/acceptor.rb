module Hickey
  module Acceptor
    module Hash
      def accept_for_hickey(klass, visitor)
        visitor.visit_hash(klass, self)
      end
    end
    module Array
      def accept_for_hickey(klass, visitor)
        visitor.visit_array(klass, self)
      end
    end
    module Object
      def accept_for_hickey(klass, visitor)
        self
      end
    end
  end
end

Object.send(:include, Hickey::Acceptor::Object)
Array.send(:include, Hickey::Acceptor::Array)
Hash.send(:include, Hickey::Acceptor::Hash)
