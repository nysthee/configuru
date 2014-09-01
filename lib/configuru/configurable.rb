module Configuru
  module Configurable
    
    module ClassMethods
      extend Forwardable
      def_delegators :configuration_class, :param, :param_names
      def configuration_class
        @configuration_class ||= Class.new do
          include Configuru::ConfigMethods 
        end
      end
      def provide_configuration(limit_to=false)
        unless [:base,:class,:module].include?(limit_to)
          # Add methods to instance
          include MainMethods
          include InstanceMethods
        end
        unless [:instance,:instances].include?(limit_to)
          # Add methods to base
          extend MainMethods
        end
      end
    end

    module MainMethods
      def configuration
        @configuruation ||= configuration_class.new
      end
      def configure(options,&block)
        configuration.configure(options,&block)
      end
    end
    
    module InstanceMethods
      def configuration_class
        self.class.configuration_class
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
    
  end
end