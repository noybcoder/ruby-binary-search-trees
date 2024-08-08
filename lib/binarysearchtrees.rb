class Tree
  class Node
    attr_accessor :data, :left_child, :right_child
    def initialize(data = nil, left_child = nil, right_child = nil)
      @data = data
      @left_child = left_child
      @right_child = right_child
    end
  end

  private_constant :Node
  attr_accessor :input, :root

  def initialize(input = get_random_input)
    @input = preprocess_array(input)
    @root = nil
  end

  def get_random_input(size = 15, range = 1..100)
    Array.new(size) { rand(range) }
  end

  def preprocess_array(array)
    array.uniq.sort
  end

end


t = Tree.new
p t.input
