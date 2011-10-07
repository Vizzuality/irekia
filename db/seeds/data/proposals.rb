#encoding: UTF-8

puts ''.green
puts 'Creating proposals...'.green
puts '====================='.green

proposal = create_proposal :title => 'Actualizar la información publicada sobre las ayudas a familias numerosas',
                           :target => @virginia,
                           :tags => %w(Comisión Transporte Gobierno\ Vasco Transporte).join(','),
                           :area => @area,
                           :author => @maria,
                           :comments => [create_comment(@andres)]

30.times do
create_proposal :target => User.politicians.sample,
                :tags => %w(Comisión Transporte Gobierno\ Vasco Transporte).join(','),
                :area => @area,
                :author => User.all.sample,
                :comments => [create_comment(@andres)]
end
