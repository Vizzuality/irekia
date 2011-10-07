#encoding: UTF-8

puts ''.green
puts 'Creating photos...'.green
puts '=================='.green

create_photo :title => 'Presentación del Gobierno Vasco 2010',
             :description => 'Presentación del Nuevo Gobierno Vasco, formado tras las elecciones de 2010',
             :image => @men_images.sample,
             :tags => %w(Comisión Transporte Gobierno\ Vasco Transporte).join(','),
             :author => @virginia,
             :comments => [
                create_comment(@maria, <<-EOF
                  Me encantaría que realmente esta gente fuera siempre a los eventos y nos lo comunicaran como en esta ocasión. La verdad que fue un buen momento para hablar con ellos y conocerlos en persona.
                EOF
                ),
                create_comment(@alberto, <<-EOF
                  Yo estuve allí y la verdad es que no fue gran cosa...
                EOF
                )
             ]

