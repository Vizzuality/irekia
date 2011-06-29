#encoding: UTF-8

module Factories

  def init_area_data
    virginia = create_user('Virginia', 'Uriarte Rodríguez')
    alberto  = create_user('Alberto', 'de Zárate López')
    user1    = create_user
    user2    = create_user
    user3    = create_user

    politic  = create_role 'Político'
    politic.users << virginia
    politic.save

    admin = create_role
    admin.users << alberto
    admin.users << user1
    admin.users << user2
    admin.users << user3
    admin.save

    citizen = create_role 'Ciudadano'

    question = create_question
    create_answer question, virginia

    area     = create_area
    area.users << virginia
    area.users << alberto
    area.users << user1
    area.users << user2
    area.users << user3
    area.contents << question
    area.contents << create_news
    area.contents << create_proposal

    area
  end

  def create_role(name = 'Administrador')
    Role.create(:name => name)
  end

  def create_user(name = random_string(rand(12)), lastname = random_string(rand(12)))
    User.create(
      :name            => name,
      :lastname        => lastname,
      :birthday        => Date.new(1980, 1, 1),
      :description     => lorem,
      :facebook_token  => random_string,
      :twitter_token   => random_string,
      :last_connection => 5.minutes.ago
    )
  end

  def create_answer(question, user)
    Answer.create(
      :body     => lorem,
      :question => question,
      :user     => user
    )
  end

  def create_area
    Area.create(
      :name        => 'Educación, Universidades e Investigación',
      :description => lorem
    )
  end

  def create_news
    News.create(
      :title => 'Inauguración del nuevo complejo deportivo en la localidad de Getxo',
      :body  => lorem
    )
  end

  def create_proposal
    Proposal.create(
      :title => ''
    )
  end

  def create_question
    Question.create(
      :title => '¿Cuándo va a ser efectiva la ayuda para estudiantes universitarios en 2011?'
    )
  end

end
RSpec.configure {|config| config.include Factories}