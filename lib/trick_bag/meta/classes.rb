# Provides useful additions to class Class.

module TrickBag
module Meta
module Classes

    VALID_ACCESS_MODES = [:public, :protected, :private, :none]

    # Enables concise and flexible creation of getters and setters
    # whose access modes for reading and writing may be different.
    #
    # Access modes can be: :public, :protected, :private, :none
    #
    # For example:
    #
    #     attr_access(:private, :none, :foo, :bar)
    #
    # will create accessors for @foo and @bar, and make them private,
    # but will not create any mutators.
    def attr_access(read_access, write_access, *attrs)
      validate_input = -> do
        [read_access, write_access].each do |access|
          unless VALID_ACCESS_MODES.include?(access)
            raise "Access mode must be one of [:public, :protected, :private]."
          end
        end
      end

      validate_input.()

      unless read_access == :none
        attr_reader(*attrs)
        send(read_access, *attrs)
      end

      unless write_access == :none
        attr_writer(*attrs)
        writers = attrs.map { |attr| "#{attr}=".to_sym }
        send(write_access, *writers)
      end
    end


    def private_attr_reader(*attrs)
      attr_access(:private, :none, *attrs)
    end


    def private_attr_writer(*attrs)
      attr_access(:none, :private, *attrs)
    end


    def private_attr_accessor(*attrs)
      attr_access(:private, :private, *attrs)
    end


    def protected_attr_reader(*attrs)
      attr_access(:protected, :none, *attrs)
    end


    def protected_attr_writer(*attrs)
      attr_access(:none, :protected, *attrs)
    end


    def protected_attr_accessor(*attrs)
      attr_access(:protected, :protected, *attrs)
    end


    def class?(name, scope = Object)
      scope.const_defined?(name) && scope.const_get(name).is_a?(Class)
    end; module_function :class?


    def undef_class(name, scope = Object)
      class_existed = class?(name, scope)
      scope.send(:remove_const, name) if class_existed
      class_existed
    end; module_function :undef_class

  end
end
end
