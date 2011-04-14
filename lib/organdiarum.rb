module Organdiarum
  def gv(digraph)
    File.open("#{digraph.name}.dot", "w") {|f| f << digraph.to_dot }
  end

  class Base
    include Comparable

    OPT_ORDER = [:dir, :label, :color, :style, :fillcolor]

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

    def opts_for_dot
      @opts.sort_by{|k, v| OPT_ORDER.index(k)}.map{|key, value| %|#{key}="#{value}"|}.join(",")
    end
  end

  class Digraph < Base
    attr_reader :vertices, :edges
    def initialize(name=nil)
      super(name)
      @vertices = []
      @edges = []
    end

    def add_vertex(vertex_or_name, opts={})
      if vertex_or_name.instance_of?(Vertex)
        @vertices << vertex_or_name
      else
        @vertices << Vertex.new(vertex_or_name, opts)
      end
    end
    alias :av :add_vertex

    def add_vertices(*vertices)
      vertices.each do |vertex|
        vertex = Vertex.new(vertex) unless vertex.instance_of?(Vertex)
        @vertices << vertex unless @vertices.include?(vertex)
      end
      self
    end
    alias :avs :add_vertices

    def add_edge(edge_or_from, to=nil, opts={})
      if edge_or_from.instance_of?(Edge)
        @edges << edge_or_from
      else
        @edges << Edge.new(edge_or_from, to, opts)
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
    def initialize(name=nil, opts={})
      super(name)
      @opts = {:label => name}.merge(opts)
      @opts.merge!(:style => "filled") if @opts[:fillcolor]
    end

    def to_s
      @name
    end

    def to_dot
      %|  #{name} [#{opts_for_dot}]|
    end
  end

  class Edge < Base
    def initialize(from, to, opts={})
      @from, @to = from, to
      @opts = {:dir => "forward", :label => ""}.merge(opts)
    end

    def to_s
      "#{@from} --> #{@to}"
    end

    def to_dot
      %|  #{@from} -> #{@to} [#{opts_for_dot}]|
    end
  end
end
