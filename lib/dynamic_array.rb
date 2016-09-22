require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    self.store = StaticArray.new(8)
    self.capacity = 8
    self.length = 0
  end

  # O(1)
  def [](index)
    check_index(index)
    store[index]
  end

  # O(1)
  def []=(index, value)
    check_index(index)
    store[index] = value
  end

  # O(1)
  def pop
    raise "index out of bounds" unless (length > 0)
    temp = store[length-1]
    store[length-1] = nil
    self.length -= 1
    temp
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if (length == capacity)
    self.length += 1
    store[length-1] = val
    nil
  end

  # O(n): has to shift over all the elements.
  def shift
    raise "index out of bounds" if (length == 0)
    val = self[0]
    (1...length).each { |i| self[i - 1] = self[i] }
    self.length -= 1
    val
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    resize! if (length == capacity)
    self.length += 1
    i = length
    while i > 0 
      if (store[i-2].nil?)
        store[i-1] = val
      else
        store[i-1] = store[i-2]
      end
      i -= 1
    end
    nil
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
    raise "index out of bounds" unless (index >= 0) && (index < length)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    updated_capacity = capacity * 2
    updated_store = StaticArray.new(updated_capacity)
    length.times do |i| 
      updated_store[i] = self[i] 
    end
    self.capacity = updated_capacity
    self.store = updated_store
  end
end
