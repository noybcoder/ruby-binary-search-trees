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
    @root = build_tree(self.input, 0, self.input.length - 1)
  end

  def get_random_input(size = 15, range = 1..100)
    Array.new(size) { rand(range) }
  end

  def preprocess_array(array)
    array.uniq.sort
  end

  def build_tree(array, first, last)
    return if first > last
    mid = first + (last - first) / 2

    node = Node.new(array[mid])
    node.left_child = build_tree(array, first, mid - 1)
    node.right_child = build_tree(array, mid + 1, last)
    node
  end

  def insert(node = self.root, data)
    return Node.new(data) if node.nil?
    return if data == node.data
    node.left_child = insert(node.left_child, data) if data < node.data
    node.right_child = insert(node.right_child, data) if data > node.data
    node
  end

  def delete(node = self.root, data)
    return node if node.nil?
    node.left_child = delete(node.left_child, data) if data < node.data
    node.right_child = delete(node.right_child,data) if data > node.data
    if data == node.data
      return node.left_child if node.right_child.nil?
      return node.right_child if node.left_child.nil?
      successor = get_successor(node.right_child)
      node.data = successor.data
      node.right_child = delete(node.right_child, successor.data)
    end
    node
  end

  def find(node = self.root, data)
    return if node.nil?
    return node if data == node.data
    find(node.left_child, data) if data < node.data
    find(node.right_child, data) if data > node.data
  end

  def level_order(node = self.root)
    return if node.nil?
    level_order(node.left_child)
    yield node if block_given?
    level_order(node.right_child)
  end

  def get_successor(current_node)
    while current_node && current_node.left_child
      current_node = current_node.left_child
    end
    current_node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end


end

t = Tree.new([2, 100, 78, 45, 20, 4, 67, 35, 19, 99, 48])
t.insert(999)
t.delete(45)
t.pretty_print
p t.level_order { |node| puts node }
