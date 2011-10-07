#encoding: UTF-8

puts ''.green
puts 'Creating users...'.green
puts '================='.green

@admin = create_user :name                  => 'Administrator',
                     :email                 => 'admin@example.com',
                     :password              => 'example',
                     :password_confirmation => 'example',
                     :inactive              => false,
                     :title                 => nil,
                     :role                  => Role.find_by_name('Administrator')



@alberto = create_user :name                  => 'Alberto',
                       :lastname              => 'de Zárate López',
                       :email                 => 'alberto.zarate@ej-gv.es',
                       :role                  => Role.find_by_name('Politician'),
                       :area_user             => AreaUser.create(:area  => @area, :display_order => 2),
                       :profile_picture       => Image.create(:image => @men_images.sample)

@virginia = create_user :name                  => 'Virginia',
                        :lastname              => 'Uriarte Rodríguez',
                        :email                 => 'virginia.uriarte@ej-gv.es',
                        :role                  => Role.find_by_name('Politician'),
                        :title                 => Title.find_by_name('Adviser'),
                        :area_user             => AreaUser.create(:area  => @area, :display_order => 1),
                        :profile_picture       => Image.create(:image => @women_images.sample)

3.times do
  name = "#{String.random(20)}"
  lastname = "#{String.random(20)} #{String.random(20)}"
  email = "#{name} #{lastname}".downcase.split(' ').join('.') + '@ej-gv.es'
  create_user :name     => name,
              :lastname => lastname,
              :email    => email,
              :area     => @area,
              :role     => Role.find_by_name('Politician')

end

@andres = create_user :name                  => 'Andrés',
                      :lastname              => 'Berzoso Rodríguez',
                      :email                 => 'andres.berzoso@gmail.com',
                      :inactive              => false,
                      :title                 => nil,
                      :profile_picture       => Image.create(:image => @men_images.sample)

@maria = create_user :name                  => 'María',
                     :lastname              => 'González Pérez',
                     :email                 => 'maria.gonzalez@gmail.com',
                     :inactive              => false,
                     :title                 => nil,
                     :profile_picture       => Image.create(:image => @women_images.sample),
                     :users_following       => User.politicians,
                     :areas_following       => Area.all

@aritz = create_user :name                  => 'Aritz',
                     :lastname              => 'Aranburu',
                     :email                 => 'aritz.aranburu@gmail.com',
                     :inactive              => false,
                     :title                 => nil,
                     :profile_picture       => Image.create(:image => @men_images.sample)


@pepito = create_user :name                  => 'José López Pérez',
                      :email                 => 'pepito@irekia.com',
                      :password              => 'irekia1234',
                      :password_confirmation => 'irekia1234'

