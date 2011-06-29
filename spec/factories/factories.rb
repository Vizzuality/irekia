#encoding: UTF-8

module Factories

  def init_area_data
    user     = create_user
    role     = create_role(user)
    area     = create_area
    question = create_question
    create_answer(question, user)
    area.contents << question
    area.contents << create_news
    area.contents << create_proposal
    area
  end

  def create_role(name = 'Administrador', user)
    role = Role.create(:name => name)
    role.users << user if user.present?
    role
  end

  def create_user
    User.create(
      :name            => 'John',
      :lastname        => 'Doe',
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