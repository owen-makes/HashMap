class HashMap # rubocop:disable Style/Documentation
  attr_accessor :buckets, :capacity, :length

  LOAD_FACTOR = 0.75

  def initialize(capacity = 16)
    @buckets = Array.new(capacity) { [] }
    @capacity = @buckets.length
    @length = 0
  end

  def set(key, value)
    resize if needs_resize?
    index = hash(key) % @capacity
    bucket = @buckets[index]
    existing_pair = bucket.find { |k, v| k == key } # rubocop:disable Lint/UnusedBlockArgument

    if existing_pair
      existing_pair[1] = value
    else
      bucket << [key, value]
      @length += 1
    end
  end

  def get(key)
    index = hash(key) % @capacity
    bucket = @buckets[index]
    x = bucket.find { |k, v| k == key } # rubocop:disable Lint/UnusedBlockArgument
    x&.fetch(1)
  end

  def has?(key)
    index = hash(key) % @capacity
    bucket = @buckets[index]
    x = bucket.find { |k, v| k == key } # rubocop:disable Lint/UnusedBlockArgument
    !x.nil?
  end

  def remove(key)
    index = hash(key) % @capacity
    bucket = @buckets[index]

    bucket.each_with_index do |(k, v), idx| # rubocop:disable Lint/UnusedBlockArgument
      if k == key
        @length -= 1
        return bucket.delete_at(idx)[1]
      end
    end
    nil
  end

  def clear
    @buckets.each(&:clear)
  end

  def keys
    key = []
    arr = @buckets.flatten

    arr.each_with_index do |k, i|
      i.odd? ? next : key << k
    end
    key
  end

  def values
    value = []
    arr = @buckets.flatten

    arr.each_with_index do |k, i|
      i.even? ? next : value << k
    end
    value
  end

  def entries
    @buckets.compact.flatten(1)
  end

  private

  def needs_resize?
    (@length.to_f / @capacity) > LOAD_FACTOR
  end

  def resize
    new_capacity = @capacity * 2
    new_buckets = Array.new(new_capacity) { [] }

    @buckets.each do |bucket|
      next if bucket.empty?

      bucket.each do |node|
        index = hash(node[0]) % new_capacity
        new_buckets[index] << node
      end
    end
    @buckets = new_buckets
    @capacity = new_capacity
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = (prime_number * hash_code) + char.ord }

    hash_code
  end
end

test = HashMap.new
test.set('apple', 'red')
test.set('banana', 'yellow')
test.set('carrot', 'orange')
test.set('dog', 'brown')
test.set('elephant', 'gray')
test.set('frog', 'green')
test.set('grape', 'purple')
test.set('hat', 'black')
test.set('ice cream', 'white')
test.set('jacket', 'blue')
test.set('kite', 'pink')
test.set('lion', 'golden')
test.set('rat', 'black')
test.set('cat', 'white')
test.set('sun', 'yellow')
test.set('moon', 'silver')

p test.buckets
