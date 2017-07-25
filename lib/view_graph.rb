require "csv"
require "pry-byebug"
require 'ruby-graphviz'

class ViewGraph
  def self.perform(file_path)
    g = GraphViz.new( :G, :type => :digraph )
    CSV.foreach(file_path, headers: true) do |row|
      a = g.add_node(row[0])
      b = g.add_node(row[1])
      g.add_edges(a, b)
    end
    g.output( :png => "user_1306.png" )
  end
end

ViewGraph.perform("#{Dir.pwd}/data/graph_edges_list_user_1306.csv")
