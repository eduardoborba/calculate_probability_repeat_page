require "csv"
require "pry-byebug"
require 'ruby-graphviz'
require 'graphviz/theory'

class GenerateGraphEdgesList
  def self.perform(file_path)
    file_content = CSV.generate_line(['id_usuario', 'idaction_url', 'number_repeats', 'larger_distance_between_repeats'])
    current_user = nil
    last_page = nil
    index = 0
    pages_accessed = []
    user_distances = {}
    number_repeats = {}
    last_page_accessed_index = {}

    CSV.foreach(file_path, headers: true) do |row|
      if current_user != row['id_usuario']
        pages_accessed.each do |page|
          file_content << CSV.generate_line([current_user, page, number_repeats[page], user_distances[page]])
        end
        current_user = row['id_usuario']
        last_page = nil
        index = 0
        pages_accessed = []
        user_distances = {}
        number_repeats = {}
        last_page_accessed_index = {}
      end

      if pages_accessed.include?(row['idaction_url'])
        number_repeats[row['idaction_url']] = number_repeats[row['idaction_url']] + 1
        if (index - last_page_accessed_index[row['idaction_url']]) > user_distances[row['idaction_url']]
          user_distances[row['idaction_url']] = index - last_page_accessed_index[row['idaction_url']]
        end
      else
        pages_accessed << row['idaction_url']
        number_repeats[row['idaction_url']] = 1
        user_distances[row['idaction_url']] = 0
      end

      last_page_accessed_index[row['idaction_url']] = index
      index = index + 1
      last_page = row['idaction_url']
    end
    pages_accessed.each do |page|
      file_content << CSV.generate_line([current_user, page, number_repeats[page], user_distances[page]])
    end

    File.open("#{Dir.pwd}/data/larger_distance_between_repeats.csv", 'w') do |file_handler|
      file_handler.write(file_content)
    end
  end
end

GenerateGraphEdgesList.perform("#{Dir.pwd}/data/preprocessed_data.csv")
