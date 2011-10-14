#encoding: UTF-8

def create_area(params)
  area = Area.find_or_create_by_name(params[:name])
  area.update_attribute(:description, Faker::Lorem.paragraph(3))
  area.description = params[:description]

  print '.'.blue

  area
end

def create_answer(params)
  defaults = {
    :text => Faker::Lorem.paragraphs(10).join("\n\n")
  }
  params = defaults.merge(params)

  answer_data = AnswerData.find_or_initialize_by_answer_text(params[:text])

  if answer_data.new_record?

    answer_data.author = params[:author]
    answer_data.question = params[:question]

    answer = Answer.new
    answer.areas = params[:areas]
    answer.users = [params[:author]]
    answer.answer_data = answer_data
    answer.comments = params[:comments] || []

    print '.'.blue

    answer.save!

    answer
  end
end

def create_argument(params)
  defaults = {
    :reason => Faker::Lorem.sentence(10),
    :in_favor => true
  }
  params = defaults.merge(params)

  argument = Argument.new
  argument.user = params[:author]
  argument.argument_data = ArgumentData.create :in_favor => params[:in_favor], :reason => params[:reason]

  case params[:proposal]
  when String
    argument.proposal = ProposalData.find_by_title(params[:proposal]).proposal
  when Integer
    argument.proposal = Proposal.find(params[:proposal])
  end

  argument.save!

  print '.'.blue

  argument
end

def create_comment(user, comment = Faker::Lorem.sentence)
  user.comments.new.create_with_body(comment)
end

def random_comments(size = nil)
  Array.new(size || rand(10)).inject([]){|array, x| array << create_comment(User.citizens.sample)}
end

def create_event(params)
  defaults = {
    :title    => Faker::Lorem.sentence(10),
    :area     => @area,
    :the_geom => "POINT(#{(-95..33).to_a.sample/10} #{(360..438).to_a.sample/10})"
  }
  params = defaults.merge(params)

  event = Event.create(
    :users                 => [params[:user]],
    :areas                 => [params[:area]],
    :the_geom              => params[:the_geom],
    :event_data_attributes => {
                               :title      => params[:title],
                               :event_date => params[:date]
    }
  )

  print '.'.blue

  event
end

def create_news(params)
  defaults = {
    :title => Faker::Lorem.sentence(7),
    :subtitle => Faker::Lorem.sentence(10),
    :body => Faker::Lorem.paragraphs(10).join("\n\n")
  }
  params = defaults.merge(params)

  news_data = NewsData.find_or_initialize_by_title(params[:title])

  if news_data.new_record?
    news_data.subtitle = params[:subtitle]
    news_data.body     = params[:body]
    news               = News.new
    news.tags          = params[:tags]
    news.areas         = [params[:area]]
    news.users         = [params[:author]]
    news.news_data     = news_data
    news.comments      = params[:comments]

    print '.'.blue

    news.save!

    news
  end
end

def create_photo(params)
  defaults = {
    :image       => (@men_images + @women_images).sample,
    :title       => Faker::Lorem.sentence(10),
    :description => Faker::Lorem.paragraphs(10).join("\n\n"),
  }
  params = defaults.merge(params)

  image = Image.create :image => params[:image],
                       :title => params[:title],
                       :description => params[:description]

  photo = Photo.create :image    => image,
                       :tags     => params[:tags],
                       :users    => [params[:author]],
                       :comments => params[:comments]

  print '.'.blue

  photo
end

def create_proposal(params)
  defaults = {
    :title => Faker::Lorem.sentence(10),
    :body => Faker::Lorem.paragraphs(10).join("\n\n")
  }

  params = defaults.merge(params)

  proposal_data = ProposalData.find_or_initialize_by_title(params[:title])

  if proposal_data.new_record?
    proposal_data.body = params[:body]

    case params[:target]
    when Area
      proposal_data.target_area = params[:target]
    when User
      proposal_data.target_user = params[:target]
    end

    proposal = Proposal.new
    proposal.tags = params[:tags]
    proposal.areas = [params[:area]]
    proposal.users = [params[:author]]
    proposal.proposal_data = proposal_data
    proposal.comments = params[:comments]

    proposal.save!

    print '.'.blue

    proposal
  end
end

def create_question(params)
  defaults = {
    :text => "¿#{Faker::Lorem.sentence(10)}?",
    :comments => []
  }
  params = defaults.merge(params)

  question_data = QuestionData.find_or_initialize_by_question_text(params[:text])

  if question_data.new_record?
    question = Question.new
    question.areas         = params[:areas]
    question.users         = params[:users]
    question.question_data = question_data
    question.comments      = params[:comments]
    question.tags          = params[:tags]

    case params[:for]
    when Area
      question_data.target_area = params[:for] if params[:for]
    when User
      question_data.target_user = params[:for] if params[:for]
    end

    question.save!

    (params[:want_an_answer] || []).each do |user|
      question.answer_requests.create :user => user
    end

    print '.'.blue

    question
  else
    question_data.question
  end
end

def create_tweet(params)
  defaults = {
    :message => Faker::Lorem.sentence(10).truncate(160),
    :status_id => '000000000000000000000'
  }
  params = defaults.merge(params)

  Tweet.create :users => [params[:author]],
               :tweet_data => TweetData.find_or_create_by_message(params[:message], :status_id => params[:status_id], :username => params[:username])
end

@women_images = %w(woman.jpeg).map{|image_name| File.open(Rails.root.join('db', 'seeds', 'support', 'images', image_name))}
@men_images   = %w(man.jpeg).map{|image_name| File.open(Rails.root.join('db', 'seeds', 'support', 'images', image_name))}

def create_user(params)
  defaults = {
    :password              => "#{params[:name].downcase}1234",
    :password_confirmation => "#{params[:name].downcase}1234",
    :is_woman              => [true, false].sample,
    :inactive              => [true, false].sample,
    :description           => Faker::Lorem.paragraphs(10).join("\n\n"),
    :province              => 'Vizcaya',
    :city                  => 'Ondarroa',
    :birthday              => rand(100).years.ago,
    :role                  => Role.find_by_name('Citizen'),
    :title                 => Title.find_by_name('Co-adviser'),
    :profile_picture       => Image.create(:image => (@men_images + @women_images).sample)
  }
  params = defaults.merge(params)

  user = User.find_or_initialize_by_name_and_lastname_and_email(params[:name], params[:lastname], params[:email])
  user.password              = params[:password]
  user.password_confirmation = params[:password_confirmation]
  user.is_woman              = params[:is_woman]
  user.inactive              = params[:inactive]
  user.description           = params[:description]
  user.province              = params[:province]
  user.city                  = params[:city]
  user.birthday              = params[:birthday]
  user.role                  = params[:role]
  user.title                 = params[:title]
  user.areas.clear
  if params[:area]
    user.areas << params[:area]
  elsif params[:area_user]
    user.areas_users << params[:area_user]
  end
  user.profile_pictures << params[:profile_picture]
  user.users_following = params[:users_following] if params[:users_following]
  user.areas_following = params[:areas_following] if params[:areas_following]
  user.save!

  print '.'.blue

  user
end

