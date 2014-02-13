# The Nature of Code
# http://natureofcode.com

class DNA
  attr_reader :genes
  def initialize(newgenes=nil)
    if newgenes
      @genes = newgenes
    else
      @genes = Array.new(1) { rand }
    end
  end

  def copy
    DNA.new(@genes.map{|x| x })
  end

  def mutate(m)
    @genes.each_index do |i|
      if rand < m
        @genes[i] = rand
      end
    end
  end
end
