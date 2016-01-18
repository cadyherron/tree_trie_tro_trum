LetterNode = Struct.new(:letter, :definition, :children, :parent, :depth)


class LetterNode

    def new
      @node = LetterNode.new
    end

end