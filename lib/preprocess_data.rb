require "csv"
require "pry-byebug"
require 'ruby-graphviz'
require 'graphviz/theory'

class GenerateGraphEdgesList
  def self.perform(file_path)
    file_content = CSV.generate_line(['id_usuario', 'idaction_url'])
    current_user = nil
    current_page = nil
    current_visit = nil

    CSV.foreach(file_path, headers: true) do |row|
      if current_page != row['idaction_url'] && current_visit == row['idvisit'] && current_user == row['custom_var_v1']
        line = []
        line << current_user
        line << row['idaction_url']
        file_content << CSV.generate_line(line)
        current_page = row['idaction_url']
      else
        current_visit = row['idvisit']
        current_user = row['custom_var_v1']
      end
    end
    File.open("#{Dir.pwd}/data/preprocessed_data.csv", 'w') do |file_handler|
      file_handler.write(file_content)
    end
  end
end

GenerateGraphEdgesList.perform("#{Dir.pwd}/data/experimento_2016_2_piwik_table_without_timestamp.csv")
