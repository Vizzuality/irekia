#encoding: UTF-8

puts ''.green
puts 'Creating answers...'.green
puts '==================='.green

@answer = create_answer :text     => 'Hola María, en realidad no va a haber ayuda este año. El recorte este',
                        :author   => @virginia,
                        :question => @question,
                        :areas    => [@area],
                        :comments => random_comments
Question.where('id <> ?', @question.id).each do |question|
  next if [true, false].sample

  create_answer :author   => User.citizens.sample,
                :question => question,
                :areas    => [@area],
                :comments => random_comments
end
