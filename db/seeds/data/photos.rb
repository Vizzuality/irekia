#encoding: UTF-8

puts ''.green
puts 'Creating photos...'.green
puts '=================='.green

(0..13).to_a.each do |i|
  create_photo :title => 'Presentación del Gobierno Vasco 2010',
               :description => 'Presentación del Nuevo Gobierno Vasco, formado tras las elecciones de 2010',
               :image => File.open(Rails.root.join(%Q{db/seeds/support/images/photo_#{"%02d" % i}.jpg})),
               :tags => %w(Comisión Transporte Gobierno\ Vasco Transporte).join(','),
               :author => User.all.sample,
               :comments => [
                  create_comment(User.citizens.sample, <<-EOF
                    Me encantaría que realmente esta gente fuera siempre a los eventos y nos lo comunicaran como en esta ocasión. La verdad que fue un buen momento para hablar con ellos y conocerlos en persona.
                  EOF
                  ),
                  create_comment(User.citizens.sample, <<-EOF
                    Yo estuve allí y la verdad es que no fue gran cosa...
                  EOF
                  )
               ]

end
