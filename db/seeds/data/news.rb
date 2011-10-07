#encoding: UTF-8

puts ''.green
puts 'Creating news...'.green
puts '================'.green

@news = create_news :title => 'Inauguración del nuevo complejo deportivo en la localidad de Getxo',
                    :tags => %w(Comisión Transporte Gobierno\ Vasco Transporte).join(','),
                    :area => @area,
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

30.times do
  create_news :tags => %w(Comisión Transporte Gobierno\ Vasco Transporte).join(','),
              :area => @area,
              :author => @virginia,
              :comments => random_comments
end
