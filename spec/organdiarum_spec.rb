require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Organdiarum" do
  describe "name" do
    it "should be set correctly when a name is provided" do
      Organdiarum::Base.new("my new base object").name.should == "my new base object"
    end

    it "should be set to a random uuid when no name is provided" do
      Organdiarum::Base.new.name.size.should == 32
    end
  end

  describe "Digraph" do
    before { @d = Organdiarum::Digraph.new }

    it "should be able to add a vertex object" do
      vertex = Organdiarum::Vertex.new("city")
      @d.add_vertex(vertex)
      @d.vertices.should == [vertex]
    end

    it "should be able to add a vertex from a string" do
      @d.add_vertex("set")
      @d.vertices.should == [Organdiarum::Vertex.new("set")]
    end

    it "should silently not add duplicate vertices" do
      @d.add_vertex("a")
      @d.add_vertices("b", "c", "a", Organdiarum::Vertex.new("A"), "city")

      @d.vertices.map(&:name).should == %w{a b c A city}
    end

    it "should add an edge from a pair of strings" do
      @d.add_vertices("a", "b")
      @d.add_edge("a", "b")

      @d.edges.map(&:to_s).should == ["a --> b"]
    end

    it "should add an edge object" do
      @d.add_vertices("a", "b")
      edge = Organdiarum::Edge.new("a", "b")
      @d.add_edge(edge)

      @d.edges.map(&:to_s).should == ["a --> b"]
    end

    it "should add multiple edges" do
      @d.add_vertices(*%w{a b c d})
      edge = Organdiarum::Edge.new("a", "b")

      @d.add_edges(edge, ["b", "c"], Organdiarum::Edge.new("d", "a"))

      @d.edges.map(&:to_s).should ==
        ["a --> b", "b --> c", "d --> a"]
    end

    it "should output to .dot format correctly" do
      @d.add_vertices(*%w{a b c d e})
      @d.add_edges(%w{a b}, %w{b c}, %w{d e})

      dot_file = <<-EOF
digraph #{@d.name} {
  a [label="a"]
  b [label="b"]
  c [label="c"]
  d [label="d"]
  e [label="e"]
  a -> b [dir=forward,label=""]
  b -> c [dir=forward,label=""]
  d -> e [dir=forward,label=""]
}
EOF
      @d.to_dot.should == dot_file.strip
    end
  end
end
