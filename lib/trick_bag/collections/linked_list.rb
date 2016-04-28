module TrickBag
module Collections

# Linked List based on git@github.com:neilparikh/ruby-linked-list.git,
# but modified somewhat.
class LinkedList

  class Node
    attr_accessor :value, :next

    def initialize(value, next_node = nil)
      @value = value
      @next = next_node
    end
  end

  attr_accessor :first
  attr_reader :length


  # @param items items with which to initialize the list
  def initialize(*items)
    @length = items.length
    @first = Node.new(items.shift)
    items.each { |item| push(item) }
  end


  # @param value value to add to end of list
  # @return self
  def push(value)
    node = Node.new(value)
    current_node = @first
    while current_node.next
      current_node = current_node.next
    end
    current_node.next = node
    @length += 1
    self
  end


  # Returns the last element from the list and removes it
  # @return the last element's value
  def pop
    case(@length)

      when 0
        raise "List is empty"

      when 1
        @length = 0
        value = @first.value
        @first = nil
        value

      else
        current = @first
        while current.next && current.next.next
          current = current.next
        end
        value = current.next.value
        current.next = nil
        @length -= 1
        value
    end
  end


  # Adds a value to the beginning of the list
  # @param value value to add to beginning of list
  # @return self
  def unshift(value)
    node = Node.new(value, @first)
    @first = node
    @length += 1
    self
  end


  # Removes the first element from the list
  # @return the first element's value
  def shift
    raise "List is empty" if @length < 1
    return_value = @first.value
    @first = @first.next
    @length -= 1
    return_value
  end


  # @return the values in this list as an array
  def to_a
    current_node = @first
    array = []
    while current_node
      array << current_node.value
      current_node = current_node.next
    end
    array
  end


  # @return the values in this list as an array
  def to_ary
    to_a
  end
end
end
end
