module Organdiarum
  def gv(digraph)
    File.open("#{digraph}.dot", "w") {|f| f << digraph.to_dot }
  end

  class Base
    include Comparable

    attr_reader :name
    def initialize(name=nil)
      @name = name || generate_uuid
    end

    def <=>(other)
      self.name <=> other.name
    end

    private

    def generate_uuid
      `uuidgen`.strip.gsub(/-/, "").gsub(/\w/) {|m| rand(10) < 5 ? m : m.downcase}
    end
  end

  class Digraph < Base
    attr_reader :vertices, :edges
    def initialize(name=nil)
      super(name)
      @vertices = []
      @edges = []
    end

    def add_vertices(*vertices)
      vertices.each do |vertex|
        vertex = Vertex.new(vertex) unless vertex.instance_of?(Vertex)
        @vertices << vertex unless @vertices.include?(vertex)
      end
      self
    end
    alias :add_vertex :add_vertices
    alias :av :add_vertices
    alias :avs :add_vertices

    def add_edge(edge_or_from, to=nil)
      if edge_or_from.instance_of?(Edge)
        @edges << edge_or_from
      else
        @edges << Edge.new(edge_or_from, to)
      end
      self
    end
    alias :ae :add_edge

    def add_edges(*edges)
      edges.each do |edge|
        add_edge(*Array(edge))
      end
      self
    end
    alias :aes :add_edges

    def to_dot
      [
        "digraph #{@name} {",
        @vertices.map{|vertex| vertex.to_dot},
        @edges.map{|edge| edge.to_dot},
        "}"
      ].flatten.join("\n")
    end

    def to_s
      ["VERTICES",
       @vertices.map{|vertex| "  #{vertex.to_s}"},
       "EDGES",
       @edges.map{|edge| " #{edge.to_s}"},
      ].flatten.join("\n")
    end
  end

  class Vertex < Base
    def initialize(name=nil)
      super(name)
    end

    def to_s
      @name
    end

    def to_dot
      %|  #{name} [label="#{name}"]|
    end
  end

  class Edge < Base
    def initialize(from, to)
      @from, @to = from, to
    end

    def to_s
      "#{@from} --> #{@to}"
    end

    def to_dot
      %|  #{@from} -> #{@to} [dir=forward,label=""]|
    end
  end
end
