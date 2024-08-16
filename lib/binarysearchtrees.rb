# frozen_string_literal: true

require_relative 'comparable'

class Tree
  include Comparable
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

  def build_tree(array, first, last)
    return if first > last

    mid = first + (last - first) / 2

    node = Node.new(array[mid])
    node.left_child = build_tree(array, first, mid - 1)
    node.right_child = build_tree(array, mid + 1, last)
    node
  end

  def insert(data, node = root)
    return Node.new(data) if node.nil?

    comparison = compare(data, node.data)
    return if comparison.zero?

    node.left_child = insert(data, node.left_child) if comparison == -1
    node.right_child = insert(data, node.right_child) if comparison == 1
    node
  end

  def delete(data, node = root)
    return node if node.nil?

    comparison = compare(data, node.data)
    node.left_child = delete(data, node.left_child) if comparison == -1
    node.right_child = delete(data, node.right_child) if comparison == 1
    if comparison.zero?
      return node.left_child if node.right_child.nil?
      return node.right_child if node.left_child.nil?

      successor = get_successor(node.right_child)
      node.data = successor.data
      node.right_child = delete(successor.data, node.right_child)
    end
    node
  end

  def find(data, node = root)
    return if node.nil?

    comparison = compare(data, node.data)
    return node if comparison.zero?

    find(data, node.left_child) if comparison == -1
    find(data, node.right_child) if comparison == 1
  end

  def level_order(node = root)
    return [] if node.nil?

    output = []
    queue = [node]
    until queue.empty?
      current = queue.shift
      block_given? ? (yield current) : output << current.data
      queue << current.left_child if current.left_child
      queue << current.right_child if current.right_child
    end
    output unless block_given?
  end

  def inorder(node = root, output = [], &block)
    return if node.nil?

    inorder(node.left_child, output, &block)
    block_given? ? (yield node) : output << node.data
    inorder(node.right_child, output, &block)
    output
  end

  def preorder(node = root, output = [], &block)
    return if node.nil?

    block_given? ? (yield node) : output << node.data
    preorder(node.left_child, output, &block)
    preorder(node.right_child, output, &block)
    output
  end

  def postorder(node = root, output = [], &block)
    return if node.nil?

    postorder(node.left_child, output, &block)
    postorder(node.right_child, output, &block)
    block_given? ? (yield node) : output << node.data
    output
  end

  def height(node = root)
    return -1 if node.nil?

    left_height = height(node.left_child)
    right_height = height(node.right_child)
    [left_height, right_height].max + 1
  end

  def depth(target, node = root)
    return -1 if node.nil?
    return 0 if target == node

    left_depth = depth(target, node.left_child)
    return left_depth + 1 unless left_depth == -1

    right_depth = depth(target, node.right_child)
    return right_depth + 1 unless right_depth == -1

    -1
  end

  def balanced?(node = root)
    return true if node.nil?

    left_height = height(node.left_child)
    right_height = height(node.right_child)
    (left_height - right_height).abs <= 1 && balanced?(node.left_child) && balanced?(node.right_child)
  end

  def rebalance
    self.input = inorder
    self.root = build_tree(input, 0, input.length - 1)
  end

  private

  def get_random_input(size = 15, range = 1..100)
    Array.new(size) { rand(range) }
  end

  def preprocess_array(array)
    array.uniq.sort
  end

  def get_successor(current_node)
    current_node = current_node.left_child while current_node&.left_child
    current_node
  end
end
