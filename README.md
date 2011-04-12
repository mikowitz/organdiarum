# organdiaRUm

organdiaRUm is beginning its life as a Ruby port/reimagination of [Organdiae][organdiae] by [Mike Solomon][apollinemike].
We'll see where it goes from there.

## Basic Usage

    ~$ irb
    irb> require "organdiarum"
    irb> include Organdiarum
    irb> g = Digraph.new
    irb> g.add_vertices("a", "b", "c", "d", "e")
    irb> g.add_edge("a", "b")
    irb> g.add_edge("a", "c")
    irb> g.add_edge("a", "d")
    irb> g.add_edges(["b", "e"], ["d", "e"])
    irb> gv(g)

should return a file that looks like

![test.svg](http://github.com/mikowitz/organdiarum/test.svg "test.svg")

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Michael Berkowitz. See LICENSE for details.

[organdiae]: http://www.organdiae.com "Organdiae"
[apollinemike]: http://www.apollinemike.com "Mike Solomon"
