require 'csv'

namespace :db do
  task :populate => :environment do
    CSV.open('F:\omim.csv', 'r').each do |row|
      Disease.create(:omim_id => row[0], :disease_name => row[1] )
    end
  end
end