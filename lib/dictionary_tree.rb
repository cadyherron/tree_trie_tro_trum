require_relative 'letter_node.rb'

# LetterNode = Struct.new(:letter, :definition, :children, :parent, :depth)


class DictionaryTree

  attr_accessor :root, :entries
  attr_reader :num_letters, :num_words, :depth

  def initialize(entries=nil)
    # entries is a 2-D array: 
    # [ ['apple', 'fruit'], 
    #   ['orange', 'citrus']  ]
    @entries = entries
    @root = LetterNode.new(nil, nil, [])
    @num_words = 0
    @num_letters = 0
    @depth = 0
    build_tree unless @entries.nil?
  end

  def insert_word(word, definition)
    current_node = @root
    letters = word.split(//)
    last_letter = letters[letters.length-1]

    letters.each do |letter|
      new_letter = LetterNode.new(letter, nil, [], current_node)
      if new_letter.letter == last_letter
        new_letter.definition = definition
      end
      current_node.children << new_letter
      current_node = new_letter
      # TODO: check if letter exists before incrementing letter
      @num_letters += 1
      @depth += 1
    end
    @num_words += 1
  end

  def build_tree
    @entries.each do |entry|
      word, definition = entry
      insert_word(word, definition)
    end
  end

  def definition_of(word)
    # word = "apple"
    # path through search = ["a","p","p","l","e"]
    # DFS to collect letters and find definition
    target_letters = word.split(//)
    stack = []
    stack << @root
    found_letters = []
    # add children to the back of the stack, evaluate from the back as well
    while letter = stack.pop
      if found_letters == target_letters
        return letter.definition
      end
      letter.children.each do |child|
        found_letters << child.letter
        stack << child
      end
    end
    puts "couldn't find the definition"
  end

  def remove_word(word)
  end

end


dt = DictionaryTree.new([['apple', 'fruit']])
p dt.root
p dt.num_letters
# dt.insert_word('apple', 'fruit')
p dt.num_words
p dt.num_letters
p dt.definition_of('apple')