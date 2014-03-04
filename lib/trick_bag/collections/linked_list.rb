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

  def initialize(*items)
    @length = items.length
    @first = Node.new(items.shift)
    items.each { |item| push(item) }
  end

  # adds value to end of list
  # returns self
  def push(value)
    node = Node.new(value)
    current_node = @first
    while current_node.next != nil
      current_node = current_node.next
    end
    current_node.next = node
    @length += 1
    self
  end

  # Removes last element from list
  # returns that element's value
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


  # adds value to beginning of list
  # returns self
  def unshift(value)
    node = Node.new(value, @first)
    @first = node
    @length += 1
    self
  end

  # Removes first element from list
  # returns that element's value
  def shift
    raise "List is empty" if @length < 1
    to_return = @first.value
    @first = @first.next
    @length -= 1
    to_return
  end

  def to_a
    current_node = @first
    array = []
    while current_node != nil
      array << current_node.value
      current_node = current_node.next
    end
    array
  end
end
end
end
