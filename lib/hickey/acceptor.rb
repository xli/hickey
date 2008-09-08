module Hickey
  module Acceptor
    module Hash
      def accept_for_hickey(klass, visitor)
        visitor.visit_hash(klass, self)
      end
    end
    module Array
      def accept_for_hickey(klass, visitor)
        collect do |o|
          o.accept_for_hickey(klass, visitor)
        end
      end
    end
  end
end

Array.send(:include, Hickey::Acceptor::Array)
Hash.send(:include, Hickey::Acceptor::Hash)
