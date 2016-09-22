require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    self.store = StaticArray.new(8)
    self.capacity = 8
    self.start_idx = 0
    self.length = 0
  end

  # O(1)
  def [](index)
    check_index(index)
    store[(start_idx + index) % capacity]
  end

  # O(1)
  def []=(index, val)
    check_index(index)
    store[(start_idx + index) % capacity] = val
  end

  # O(1)
  def pop
    if (length == 0)
      raise "index out of bounds"
    end
    temp = self[length-1]
    self[length-1] = nil
    self.length -= 1
    temp
  end

  # O(1) ammortized
  def push(val)
    resize! if length == capacity
    self.length += 1
    self[length-1] = val
    nil
  end

  # O(1)
  def shift
    raise "index out of bounds" if (length == 0)
    val = self[0]
    self[0] = nil
    self.start_idx = (start_idx + 1) % capacity
    self.length -= 1
    val
  end

  # O(1) ammortized
  def unshift(val)
    resize! if (length == capacity)
    self.start_idx = (start_idx - 1) % capacity
    self.length += 1
    self[0] = val
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    raise "index out of bounds" unless (index >= 0) && (index < length)
  end

  def resize!
    new_capacity = capacity * 2
    new_store = StaticArray.new(new_capacity)
    length.times do |i| 
      new_store[i] = self[i]
    end
    self.capacity = new_capacity
    self.store = new_store
    self.start_idx = 0
  end
end
