require "csv"
require "pry-byebug"
require 'ruby-graphviz'

class GenerateGraphEdgesList
  def self.perform(file_path)
    current_user = nil
    current_page = nil
    current_graph = []
    users_graph = {}

    CSV.foreach(file_path, headers: true) do |row|
      if current_user != row['id_usuario']
        users_graph[current_user] = current_graph unless current_user.nil?
        current_graph = []
        current_user = row['id_usuario']
        current_page = row['idaction_url']
      end

      current_graph << [current_page, row['idaction_url']]
      current_page = row['idaction_url']
    end

    users_graph[current_user] = current_graph
    users_graph.map do |id_usuario, user_graph|
      save_edges_list(id_usuario, user_graph)

      save_graph_viz(id_usuario, user_graph)
    end
  end

  def self.save_edges_list(id_usuario, edges_list)
    File.open("#{Dir.pwd}/data/graph_edges_list_user_#{id_usuario}.csv", 'w') do |file_handler|
      edges_list.each do |edge|
        file_handler.write(CSV.generate_line(edge))
      end
    end
  end

  def self.save_graph_viz(id_usuario, edges_list)
    g = GraphViz.new(:G, :type => :digraph)
    edges_list.each do |edge|
      a = g.add_node(edge[0])
      b = g.add_node(edge[1])
      g.add_edges(a, b)
    end

    g.output( :png => "#{Dir.pwd}/graphs/user_#{id_usuario}.png" )
  end
end

GenerateGraphEdgesList.perform("#{Dir.pwd}/data/preprocessed_data.csv")
