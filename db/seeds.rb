# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.destroy_all
Klu.destroy_all

User.create(:firstname => 'kluuu', :lastname => 'master', :email => 'admin@kluuu.com', :password => 'aendere_mich', :password_confirmation => 'aendere_mich')

Role.destroy_all
Role.create([{name: 'admin'}, {name: 'user'}])

Category.destroy_all
h = { "culture" => "Kultur", "technics" => "Technik", "education" => "Bildung", "living" => "Leben" }
I18n.locale = :en
cats = []
h.keys.each do |k|
  cats.push Category.create(:name => k)
end

I18n.locale = :de
cats.each_with_index do |category,i|
  category.name = h.values[i]
  category.save!
end
