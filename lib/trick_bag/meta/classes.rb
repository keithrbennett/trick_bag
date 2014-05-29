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
    # will create readers (aka accessors or getters) for @foo and @bar,
    # and make them private, but will not create any writers
    # (aka mutators or setters).
    def attr_access(read_access, write_access, *attrs)
      validate_input = -> do
        [read_access, write_access].each do |access|
          unless VALID_ACCESS_MODES.include?(access)
            raise "Access mode must be one of #{VALID_ACCESS_MODES.inspect}]."
          end
        end
      end

      validate_input.()

      unless read_access == :none
        attr_reader(*attrs)
        send(read_access, *attrs) # e.g. results in protected :foo, :bar
      end

      unless write_access == :none
        attr_writer(*attrs)
        writers = attrs.map { |attr| "#{attr}=".to_sym }
        send(write_access, *writers) # e.g. results in private :foo=, :bar=
      end
    end


    # Creates private readers and no writers for the specified attributes.
    def private_attr_reader(*attrs)
      attr_access(:private, :none, *attrs)
    end


    # Creates private writers and no readers for the specified attributes.
    def private_attr_writer(*attrs)
      attr_access(:none, :private, *attrs)
    end


    # Creates private readers and writers for the specified attributes.
    def private_attr_accessor(*attrs)
      attr_access(:private, :private, *attrs)
    end


    # Creates protected readers and no writers for the specified attributes.
    def protected_attr_reader(*attrs)
      attr_access(:protected, :none, *attrs)
    end


    # Creates protected writers and no readers for the specified attributes.
    def protected_attr_writer(*attrs)
      attr_access(:none, :protected, *attrs)
    end


    # Creates protected readers and writers for the specified attributes.
    def protected_attr_accessor(*attrs)
      attr_access(:protected, :protected, *attrs)
    end


    # Returns whether or not the specified name is a defined class.
    # @param class class name (a string)
    # @param scope scope in which the class would be defined, defaults to Object
    #        (e.g. could be MyModule::InnerModule)
    #
    # e.g. module M; class X; end; end;  class?('X', M) => true
    def class?(name, scope = Object)
      scope.const_defined?(name) && scope.const_get(name).is_a?(Class)
    end; module_function :class?


    # Undefines a class; useful for unit testing code that manipulates classes.
    #
    # @param name  name of class to undefine
    # @param scope scope in which the class is defined, defaults to Object
    #
    # e.g. module M; class X; end; end;  class?('X', M) => true
    # undef_class('X', M);               class?('X', M) => false
    def undef_class(name, scope = Object)
      class_existed = class?(name, scope)
      scope.send(:remove_const, name) if class_existed
      class_existed
    end; module_function :undef_class

  end
end
end
