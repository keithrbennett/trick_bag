require_relative '../../spec_helper'
require 'trick_bag/meta/classes'

module TrickBag
module Meta

describe Classes do

  after(:each) { Classes.undef_class('ClassPatchTestClass') }


####################################################### class?

context 'class?' do

  it 'should recognize String as a class' do
    expect(Classes.class?('String')).to be_true
  end

  it 'should recognize that RUBY_PLATFORM is defined but is not a class' do
    expect(Classes.class?('RUBY_PLATFORM')).to be_false
  end

  it 'should recognize a nonexistent constant as not being a class' do
    expect(Classes.class?('Afjkdiurqpweruwiqopurqpweriuqewprzvxcvzxcvzxvzvzvzvcxzvzv')).to be_false
  end
end


####################################################### undef_class

  context 'undef_class' do
    it 'should remove the class' do
      fn = -> do
        class ClassPatchTestClass; end
        ClassPatchTestClass.new # to illustrate that it's available
        Classes.undef_class('ClassPatchTestClass', TrickBag::Meta)
      end
      fn.()
      expect(->{ ClassPatchTestClass.new }).to raise_error
    end
  end


####################################################### private_attr_reader

  context 'private_attr_reader' do

    after(:each) { Classes.undef_class('ClassPatchTestClass') }

    fn_create_class = ->do
      class ClassPatchTestClass

        extend Classes

        private_attr_reader :foo

        def initialize
          @foo = 123
          puts "foo = #{self.foo}"
        end
      end
    end


      it "should be visible inside the class" do
      expect(fn_create_class).not_to raise_error
    end

    it "should be invisible outside the class" do
      fn_create_class.()
      expect(->{ ClassPatchTestClass.new.foo }).to raise_error
    end
  end


####################################################### private_attr_writer

  context 'private_attr_writer' do

    fn_create_class = ->do
      class ClassPatchTestClass

        extend Classes

        private_attr_writer :foo

        def initialize
          self.foo = 123
        end
      end
    end


    it "should be visible inside the class" do
      expect(fn_create_class).not_to raise_error
    end

    it "should be invisible outside the class" do
      fn_create_class.()
      expect(->{ ClassPatchTestClass.new.foo = 456}).to raise_error
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


    it "should be visible inside the class" do
      expect(fn_create_class).not_to raise_error
    end

    it "should be invisible outside the class" do
      fn_create_class.()
      expect(->{ ClassPatchTestClass.new.foo = 456}).to raise_error
      expect(->{ ClassPatchTestClass.new.foo }).to raise_error
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


    it "should be readable and writable inside the class" do
      expect(fn_create_class).not_to raise_error
    end

    it "should be readable outside the class" do
      fn_create_class.()
      expect(->{ ClassPatchTestClass.new.foo }).not_to raise_error
    end

    it "should not be writable outside the class" do
      fn_create_class.()
      expect(->{ ClassPatchTestClass.new.foo = 456}).to raise_error
    end
  end

  context 'attr_access(:private, :none, :foo)' do

    fn_create_class = ->do
      class ClassPatchTestClass

        extend Classes

        attr_access :private, :none, :foo

        def initialize
          @foo = 1
          self.foo
        end
      end
    end


    it "should be readable inside the class" do
      expect(fn_create_class).not_to raise_error
    end


    it "should not be readable outside the class" do
      fn_create_class.()
      expect(->{ ClassPatchTestClass.new.foo }).to raise_error
    end

    it "should not be readable outside the class" do
      fn_create_class.()
      expect(->{ ClassPatchTestClass.new.foo }).to raise_error
    end

    it "should not be writable outside the class" do
      fn_create_class.()
      expect(->{ ClassPatchTestClass.new.foo = 456}).to raise_error
    end
  end
end
end
end
