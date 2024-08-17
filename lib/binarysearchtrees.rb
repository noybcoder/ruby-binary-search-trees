# frozen_string_literal: true

require_relative 'comparable' # Require a custom Comparable module for node comparison

# Tree class that represents the Binary Search Tree data structure.
class Tree
  include Comparable # Include the Comparable module to enable custom comparisons

  # Inner class to represent a node in the binary search tree
  class Node
    # Allows the read and write access to the instance variables
    attr_accessor :data, :left_child, :right_child

    # Public: Initializes a new node.
    #
    # data - The data assigned to the new node (default: nil).
    # left_child - The pointer to the immediate child on the left (default: nil).
    # right_child - The pointer to the immediate child on the right (default: nil).
    #
    # Returns a new Node object.
    def initialize(data = nil, left_child = nil, right_child = nil)
      @data = data # Assign the data
      @left_child = left_child # Assign the pointer to the left child
      @right_child = right_child # Assign the pointer to the right child
    end
  end

  private_constant :Node # Makes the Node class private within Tree
  # Allows the read and write access to the instance variables
  attr_accessor :input, :root

  # Public: Initializes a new Tree.
  #
  # input - An array of values to initialize the tree with (default: a random array).
  #
  # The tree is constructed from a sorted, unique version of the input array.
  def initialize(input = get_random_input)
    @input = preprocess_array(input) # Preprocess the array (remove duplicates and sort)
    @root = build_tree(self.input, 0, self.input.length - 1) # Build a balanced BST from the array
  end

  # Public: Recursively builds a balanced binary search tree from a sorted array.
  #
  # array - The sorted array from which to build the tree.
  # first - The starting index of the current subtree.
  # last - The ending index of the current subtree.
  #
  # Returns the root node of the constructed subtree.
  def build_tree(array, first, last)
    return if first > last # Base case: no elements to process

    mid = first + (last - first) / 2 # Find the middle element

    node = Node.new(array[mid]) # Create a new node with the middle element
    node.left_child = build_tree(array, first, mid - 1) # Recursively build the left subtree
    node.right_child = build_tree(array, mid + 1, last) # Recursively build the right subtree
    node # Return the root of this subtree
  end

  # Public: Inserts a new data value into the tree, maintaining BST properties.
  #
  # data - The data value to insert into the tree.
  # node - The current node in the recursion (default: root of the tree).
  #
  # Uses the custom compare method to determine the insertion point.
  # Returns the updated subtree with the new data value inserted.
  def insert(data, node = root)
    return Node.new(data) if node.nil? # Base case: Insert here if the node is empty

    comparison = compare(data, node.data) # Compare the new data with the current node's data
    return if comparison.zero? # Do nothing if the data is equal (no duplicates)

    # Recursively insert into the left or right subtree based on the comparison
    node.left_child = insert(data, node.left_child) if comparison == -1
    node.right_child = insert(data, node.right_child) if comparison == 1
    node # Return the updated subtree
  end

  # Public: Deletes a node with the specified data value from the tree.
  #
  # data - The data value to delete from the tree.
  # node - The current node in the recursion (default: root of the tree).
  #
  # Handles different cases: node with no child, one child, and two children.
  # Returns the updated subtree with the specified data value removed.
  def delete(data, node = root)
    return node if node.nil? # Base case: the data is not found

    comparison = compare(data, node.data) # Compare the data with the current node's data
    # Recursively delete from the left subtree
    node.left_child = delete(data, node.left_child) if comparison == -1
    # Recursively delete from the right subtree
    node.right_child = delete(data, node.right_child) if comparison == 1
    if comparison.zero?
      # Node with only one child or no child
      return node.left_child if node.right_child.nil?
      return node.right_child if node.left_child.nil?

      # Node with two children: find the in-order successor
      successor = get_successor(node.right_child)
      node.data = successor.data # Replace current node's data with the successor's data
      node.right_child = delete(successor.data, node.right_child) # Delete the successor node
    end
    node # Return the updated subtree
  end

  # Public: Finds and returns the node with the specified data value.
  #
  # data - The data value to search for in the tree.
  # node - The current node in the recursion (default: root of the tree).
  #
  # Returns the node containing the data, or nil if not found.
  def find(data, node = root)
    return if node.nil? # Base case: the data is not found

    comparison = compare(data, node.data) # Compare the data with the current node's data
    return node if comparison.zero? # Data found

    # Recursively search in the left or right subtree based on the comparison
    find(data, node.left_child) if comparison == -1
    find(data, node.right_child) if comparison == 1
  end

  # Public: Performs a level-order traversal (breadth-first) of the tree.
  #
  # node - The starting node for the traversal (default: root of the tree).
  #
  # If a block is given, yields each node to the block; otherwise, returns an array of node data.
  # Returns an array of node data if no block is given.
  def level_order(node = root)
    return [] if node.nil? # Return empty array if the tree is empty

    output = []
    queue = [node] # Initialize a queue with the root node
    until queue.empty?
      current = queue.shift # Dequeue the next node
      block_given? ? (yield current) : output << current.data # Process the current node
      queue << current.left_child if current.left_child # Enqueue the left child
      queue << current.right_child if current.right_child # Enqueue the left child
    end
    output unless block_given? # Return the collected data if no block was given
  end

  # Public: Performs an in-order traversal (left-root-right) of the tree.
  #
  # node - The starting node for the traversal (default: root of the tree).
  # output - The array to store the traversal results (default: empty array).
  # block - An optional block to process each node during traversal.
  #
  # If a block is given, yields each node to the block; otherwise, returns an array of node data.
  # Returns an array of node data if no block is given.
  def inorder(node = root, output = [], &block)
    return if node.nil? # Base case: do nothing if the node is nil

    inorder(node.left_child, output, &block) # Traverse the left subtree
    block_given? ? (yield node) : output << node.data # Process the current node
    inorder(node.right_child, output, &block) # Traverse the right subtree
    output # Return the collected data
  end

  # Public: Performs a pre-order traversal (root-left-right) of the tree.
  #
  # node - The starting node for the traversal (default: root of the tree).
  # output - The array to store the traversal results (default: empty array).
  # block - An optional block to process each node during traversal.
  #
  # If a block is given, yields each node to the block; otherwise, returns an array of node data.
  # Returns an array of node data if no block is given.
  def preorder(node = root, output = [], &block)
    return if node.nil? # Base case: do nothing if the node is nil

    block_given? ? (yield node) : output << node.data # Process the current node
    preorder(node.left_child, output, &block) # Traverse the left subtree
    preorder(node.right_child, output, &block) # Traverse the right subtree
    output # Return the collected data
  end

  # Public: Performs a post-order traversal (left-right-root) of the tree.
  #
  # node - The starting node for the traversal (default: root of the tree).
  # output - The array to store the traversal results (default: empty array).
  # block - An optional block to process each node during traversal.
  #
  # If a block is given, yields each node to the block; otherwise, returns an array of node data.
  # Returns an array of node data if no block is given.
  def postorder(node = root, output = [], &block)
    return if node.nil? # Base case: do nothing if the node is nil

    postorder(node.left_child, output, &block) # Traverse the left subtree
    postorder(node.right_child, output, &block) # Traverse the right subtree
    block_given? ? (yield node) : output << node.data # Process the current node
    output # Return the collected data
  end

  # Public: Calculates the height of the tree, which is the number of edges
  # from the root to the furthest leaf node.
  #
  # node - The current node in the recursion (default: root of the tree).
  #
  # Returns the height of the tree as an Integer.
  def height(node = root)
    return -1 if node.nil? # Base case: height of an empty tree is -1

    left_height = height(node.left_child) # Recursively calculate the height of the left subtree
    right_height = height(node.right_child) # Recursively calculate the height of the right subtree
    [left_height, right_height].max + 1 # Return the maximum height plus one for the current node
  end

  # Public: Calculates the depth of a given node in the tree, which is the
  # number of edges from the root to the target node.
  #
  # target - The node whose depth is being calculated.
  # node - The current node in the recursion (default: root of the tree).
  #
  # Returns the depth of the node as an Integer, or -1 if the node is not found.
  def depth(target, node = root)
    return -1 if node.nil? # Base case: depth of an empty tree is -1
    return 0 if target == node # The depth of the root node is 0

    # Recursively calculate the depth in the left subtree
    left_depth = depth(target, node.left_child)
    return left_depth + 1 unless left_depth == -1 # If found, return the depth plus one

    # Recursively calculate the depth in the right subtree
    right_depth = depth(target, node.right_child)
    return right_depth + 1 unless right_depth == -1 # If found, return the depth plus one

    -1 # If the node is not found in either subtree, return -1
  end

  # Public: Checks if the tree is balanced. A balanced tree is one where the
  # difference in height between the left and right subtrees is no more than 1
  # for any node.
  #
  # node - The current node in the recursion (default: root of the tree).
  #
  # Returns true if the tree is balanced, false otherwise.
  def balanced?(node = root)
    return true if node.nil? # An empty tree is balanced

    # Calculate the height of the left and right subtrees
    left_height = height(node.left_child)
    right_height = height(node.right_child)
    # Check if the current node is balanced and recursively check the subtrees
    (left_height - right_height).abs <= 1 && balanced?(node.left_child) && balanced?(node.right_child)
  end

  # Public: Rebalances the tree to ensure it is balanced. This method rebuilds
  # the tree from the sorted array of its elements.
  #
  # The tree is rebuilt to ensure the height is minimized, creating a balanced BST.
  def rebalance
    self.input = inorder # Get the sorted array of the current tree elements
    self.root = build_tree(input, 0, input.length - 1) # Rebuild the tree from the sorted array
  end

  private

  # Private: Generates a random array of integers to be used as the input
  # for initializing the tree.
  #
  # size - The number of elements in the array (default: 15).
  # range - The range within which the random numbers are generated (default: 1..100).
  #
  # Returns an array of random integers.
  def get_random_input(size = 15, range = 1..100)
    Array.new(size) { rand(range) } # Generate an array of random integers
  end

  # Private: Preprocesses the input array by removing duplicates and sorting
  # the elements.
  #
  # array - The input array to preprocess.
  #
  # Returns a sorted array with unique elements.
  def preprocess_array(array)
    array.uniq.sort # Remove duplicates and sort the array
  end

  # Private: Finds the in-order successor of the given node, which is the node
  # with the smallest value in the right subtree.
  #
  # current_node - The node whose in-order successor is to be found.
  #
  # Returns the node that is the in-order successor.
  def get_successor(current_node)
    # Find the leftmost child
    current_node = current_node.left_child while current_node&.left_child
    current_node # Return the successor node
  end
end
