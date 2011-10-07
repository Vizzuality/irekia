#encoding: UTF-8

puts ''.green
puts 'Creating questions...'.green
puts '====================='.green

create_question :text           => '¿Cuándo va a ser efectiva la ayuda para estudiantes universitarios en 2011?',
                :areas          => [@area],
                :users          => [@maria],
                :for            => @virginia,
                :comments       => [create_comment(@andres)],
                :tags           => %w(Comisión Transporte Gobierno\ Vasco Transporte).join(','),
                :want_an_answer => [@andres, @aritz, @maria]

@question = create_question :text  => 'Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos.',
                            :areas => [@area],
                            :users => [@maria],
                            :for   => @virginia,
                            :tags  => %w(Comisión Transporte Gobierno\ Vasco Transporte).join(',')

30.times do
  create_question :areas    => [@area],
                  :users    => [User.citizens.sample],
                  :for      => [User.politicians.sample, @area].sample,
                  :tags     => %w(Comisión Transporte Gobierno\ Vasco Transporte).join(','),
                  :comments => random_comments
end
