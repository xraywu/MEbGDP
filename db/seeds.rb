# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Disease.create(:omim_id => '194050', :disease_name => 'WILLIAMS-BEUREN SYNDROME')
Disease.create(:omim_id => '609757', :disease_name => 'WILLIAMS-BEUREN REGION DUPLICATION SYNDROME')
Disease.create(:omim_id => '228960', :disease_name => 'HIGH MOLECULAR WEIGHT KININOGEN DEFICIENCY')

