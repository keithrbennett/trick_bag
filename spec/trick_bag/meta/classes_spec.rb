require_relative '../../spec_helper'
require 'trick_bag/meta/classes'

module TrickBag
module Meta

describe Classes do

  after(:each) { Classes.undef_class('ClassPatchTestClass', TrickBag::Meta) }


####################################################### class?

context 'class?' do

  it 'should recognize String as a class' do
    expect(Classes.class?('String')).to eq(true)
  end

  it 'should recognize that RUBY_PLATFORM is not a class even though it is a defined constant' do
    expect(Classes.class?('RUBY_PLATFORM')).to eq(false)
  end

  it 'should recognize a nonexistent constant as not being a class' do
    expect(Classes.class?('Afjkdiurqpweruwiqopurqpweriuqewprzvxcvzxcvzxvzvzvzvcxzvzv')).to eq(false)
  end
end


####################################################### undef_class

  context 'undef_class' do
    it 'should remove the class' do
      fn = -> do
        class ClassPatchTestClass; end
        expect(ClassPatchTestClass.new.class).to eq(ClassPatchTestClass) # to illustrate that it's available
        Classes.undef_class('ClassPatchTestClass', TrickBag::Meta)
      end
      fn.()
      expect(->{ ClassPatchTestClass.new }).to raise_error(NameError)
    end
  end


####################################################### private_attr_reader

  context 'private_attr_reader' do

    fn_create_class = ->do
      class ClassPatchTestClass
        extend Classes
        private_attr_reader :foo
      end
    end


    it "should be a private method" do
      fn_create_class.()
      expect(ClassPatchTestClass.private_method_defined?(:foo)).to eq(true)
    end
  end


####################################################### private_attr_writer

  context 'private_attr_writer' do

    fn_create_class = ->do
      class ClassPatchTestClass
        extend Classes
        private_attr_writer :foo
      end
    end

    it "should be a private method" do
      fn_create_class.()
      expect(ClassPatchTestClass.private_method_defined?(:foo=)).to eq(true)
    end
  end

####################################################### private_attr_accessor

  context 'private_attr_accessor' do

    fn_create_class = ->do
      class ClassPatchTestClass

        extend Classes

        private_attr_accessor :foo

        def initialize
          self.foo = 123
          puts self.foo
        end
      end
    end


    it "should be private reader and writer" do
      fn_create_class.()
      expect(ClassPatchTestClass.private_method_defined?(:foo)).to eq(true)
      expect(ClassPatchTestClass.private_method_defined?(:foo=)).to eq(true)
    end
  end


####################################################### private_attr_writer_public_reader

  context 'attr_access(:public, :private, :foo)' do

    fn_create_class = ->do
      class ClassPatchTestClass

        extend Classes

        attr_access :public, :private, :foo

        def initialize
          self.foo = 123
          self.foo
        end
      end
    end


    it "should be a public reader" do
      fn_create_class.()
      expect(ClassPatchTestClass.public_method_defined?(:foo)).to eq(true)
    end

    it "should be a private writer" do
      fn_create_class.()
      expect(ClassPatchTestClass.private_method_defined?(:foo=)).to eq(true)
    end
  end


  context 'attr_access(:private, :none, :foo)' do

    fn_create_class = ->do
      class ClassPatchTestClass
        extend Classes
        attr_access :private, :none, :foo
      end
    end

    it "should be a private reader" do
      fn_create_class.()
      expect(ClassPatchTestClass.private_method_defined?(:foo)).to eq(true)
    end

    it 'should not contain a writer at all' do
      fn_create_class.()
      expect(ClassPatchTestClass.private_method_defined?(:foo=)).to eq(false)
      expect(ClassPatchTestClass.protected_method_defined?(:foo=)).to eq(false)
      expect(ClassPatchTestClass.public_method_defined?(:foo=)).to eq(false)
    end
  end
end
end
end
