require_relative 'lib/binarysearchtrees'

tree = Tree.new
puts 'Initially'
puts "Is the tree balanced? #{tree.balanced?}"

puts "Level order traversal: #{tree.level_order}"
puts "Pre-order traversal: #{tree.preorder}"
puts "Post-order traversal: #{tree.postorder}"
puts "In-order traversal: #{tree.inorder}\n\n"

tree.insert(101)
tree.insert(1001)
tree.insert(200)
tree.insert(999)

puts 'After adding new nodes'
puts "Is the tree balanced now after adding new node: #{tree.balanced?}\n\n"

tree.rebalance
puts 'After rebalancing'
puts "Is the tree balanced now after rebalancing? #{tree.balanced?}"
puts "Level order traversal: #{tree.level_order}"
puts "Pre-order traversal: #{tree.preorder}"
puts "Post-order traversal: #{tree.postorder}"
puts "In-order traversal: #{tree.inorder}"
