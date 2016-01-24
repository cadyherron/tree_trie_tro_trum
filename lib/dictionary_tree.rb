require_relative 'letter_node.rb'
require 'pp'

# LetterNode = Struct.new(:letter, :definition, :children, :parent, :depth)


class DictionaryTree

  attr_accessor :root, :entries
  attr_reader :num_letters, :num_words, :depth

  def initialize(entries=nil)
    # entries is a 2-D array: 
    # [ ['apple', 'fruit'], 
    #   ['orange', 'citrus']  ]
    @entries = entries
    @root = LetterNode.new(nil, nil, [], nil, 0)
    build_tree if @entries
  end


  def insert_word(word, definition)
    current_node = @root
    letters = word.split(//)
    last_letter = letters[letters.length-1]

    letters.each do |letter|
      # if current letter's parent has a child that is the same
      # letter that we're adding, don't add this letter as a child
      unless current_node.children.find { |current_node| current_node.letter == letter }
        new_letter = LetterNode.new(letter, nil, [], current_node, current_node.depth+1)
        current_node.children << new_letter
        current_node = new_letter
      end
    end
    current_node.definition = definition
  end


  def build_tree
    @entries.each do |entry|
      word, definition = entry
      insert_word(word, definition)
    end
  end


  def find_node(word, current_node=@root)
    return current_node if word.empty?
    next_node = current_node.children.find {|child| child.letter == word[0]}
    return false unless next_node
    find_node(word[1..-1], next_node)
  end


  def definition_of(word)
    if node = find_node(word)
      node.definition
    else
      puts "couldn't find the definition"
    end
  end


  def num_letters
    count = 0
    stack = []
    stack << @root

    while current_node = stack.pop
      current_node.children.each do |child|
        count += 1 if child.letter
        stack << child
      end
    end
    count
  end


  def num_words
    count = 0
    stack = []
    stack << @root

    while current_node = stack.pop
      current_node.children.each do |child|
        count += 1 if child.definition
        stack << child
      end
    end
    count
  end


  def depth
    depths = []
    stack = []
    stack << @root
    while current_node = stack.pop
      current_node.children.each do |child|
        depths << child.depth
        stack << child
      end
    end
    depths.max
  end


  def remove_word(word)
    current_node = find_node(word)
    return false unless current_node
    unless current_node.children.empty?
      return node.definition = nil
    end
    until current_node.parent.definition || current_node.parent.children.size > 1 || current_node.parent == @root
      current_node = current_node.parent
    end
    current_node.parent.children.delete(current_node)
  end

end


dt = DictionaryTree.new([['apple', 'fruit'], ['cat', 'animal'], ['apiary', 'birds']])
# pp dt.root
# p dt.num_letters
# dt.insert_word('apiary', 'birds')

p dt.num_words
p dt.num_letters
p dt.depth
dt.insert_word('catch', 'the ball')
p dt.num_letters
p dt.num_words

# dt.remove_word('cat')
# pp dt.root
