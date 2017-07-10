require "csv"
require "pry-byebug"

class CalculateProbabilityRepeatPage
  def self.perform(file_path)
    file_content = CSV.generate_line([
      "id_usuario",
      "probability_repeat_page",
      "probability_repeat_page_except_initial",
      "number_pages_repeated",
      "number_pages_repeated_except_inital",
      "number_pages_accessed"
    ])
    current_user = nil
    pages_accessed = []
    number_pages_repeated = 0.0
    number_pages_repeated_except_inital = 0.0
    probability_repeat_page = {}
    probability_repeat_page_except_initial = {}
    id_visit = nil

    CSV.foreach(file_path, headers: true) do |row|
      if row['id_usuario'] != current_user
        unless current_user.nil?
          line = []
          line << current_user
          line << number_pages_repeated / pages_accessed.count
          line << number_pages_repeated_except_inital / pages_accessed.count
          line << number_pages_repeated
          line << number_pages_repeated_except_inital
          line << pages_accessed.count
          file_content << CSV.generate_line(line)
        end
        current_user = row['id_usuario']
        pages_accessed = []
        number_pages_repeated = 0.0
        number_pages_repeated_except_inital = 0.0
        id_visit = row['idvisit']
      end

      if pages_accessed.include?(row['idaction_url'])
        if id_visit != row['idvisit']
          id_visit = row['idvisit']
        else
          number_pages_repeated_except_inital = number_pages_repeated_except_inital + 1.0
        end
        number_pages_repeated = number_pages_repeated + 1.0
      end

      pages_accessed << row['idaction_url']
    end
    line = []
    line << current_user
    line << number_pages_repeated / pages_accessed.count
    line << number_pages_repeated_except_inital / pages_accessed.count
    line << number_pages_repeated
    line << number_pages_repeated_except_inital
    line << pages_accessed.count
    file_content << CSV.generate_line(line)

    File.open("#{Dir.pwd}/data/probability_repeat_page.csv", 'w') do |file_handler|
      file_handler.write(file_content)
    end
  end
end

CalculateProbabilityRepeatPage.perform("#{Dir.pwd}/data/experimento_2016_2_piwik_table_without_timestamp.csv")
