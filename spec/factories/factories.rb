#encoding: UTF-8

module Factories

  def init_area_data
    consejera      = create_title('Consejera')
    vice_consejero = create_title('Vice-consejero')

    virginia       = create_user('Virginia', 'Uriarte Rodríguez')
    virginia.title = consejera
    virginia.save
    alberto        = create_user('Alberto', 'de Zárate López')
    alberto.title  = vice_consejero
    alberto.save
    user1          = create_user
    user2          = create_user
    user3          = create_user

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

    area     = create_area

    area.users << virginia
    area.users << alberto
    area.users << user1
    area.users << user2
    area.users << user3

    create_content_status('open')
    create_content_status('closed')

    question = create_question(:title => '¿Cuándo va a ser efectiva la ayuda para estudiantes universitarios en 2011?', :area => area)
    create_answer question, virginia
    create_news(:title => 'Inauguración del nuevo complejo deportivo en la localidad de Getxo', :area => area)
    create_proposal(:area => area)

    create_answer create_question(:area => area), alberto
    create_news(:area => area)
    create_proposal(:area => area, :status => ContentStatus.closed_proposal)
    create_question(:area => area)
    create_news(:area => area)
    create_proposal(:area => area, :status => ContentStatus.closed_proposal)
    create_question(:area => area)
    create_news(:area => area)
    create_proposal(:area => area)

    Delorean.time_travel_to "1 week ago" do
      create_question(:area => area)
      create_news(:area => area)
      create_proposal(:area => area)
    end

    area
  end

  def create_role(name = 'Administrador')
    Role.create(:name => name)
  end

  def create_user(name = "#{random_string(rand(12))} #{random_string(rand(12))} #{random_string(rand(12))}" )
    User.create(
      :name            => name
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

  def create_news(options = {})
    default_options = {:title => random_string(50)}
    options = default_options.merge(options)

    news = News.new(
      :title => options[:title],
      :body  => lorem
    )

    news.areas << options[:area] if options[:area].present?
    news.save!
    news
  end

  def create_proposal(options = {})
    default_options = {:title => random_string(50)}
    options = default_options.merge(options)

    proposal = Proposal.new(
      :title => options[:title]
    )

    proposal.areas << options[:area] if options[:area].present?
    proposal.status = options[:status] if options[:status].present?
    proposal.save!
    proposal
  end

  def create_question(options = {})
    default_options = {:title => random_string(50)}
    options = default_options.merge(options)

    question = Question.new(
      :title => options[:title]
    )

    question.areas << options[:area] if options[:area].present?
    question.save!
    question
  end

  def create_title(name)
    Title.create(
      :name => name
    )
  end

  def create_content_status(name)
    ContentStatus.create(
      :name => name
    )
  end

end
RSpec.configure {|config| config.include Factories}