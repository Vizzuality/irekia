#encoding: UTF-8

def create_area(params)
  area = Area.find_or_initialize_by_name(params[:name])
  area.image = Image.create(:image => params[:image]) if params[:image]
  area.description    = params[:description]
  area.description_1  = params[:description_1]
  area.description_2  = params[:description_2]
  area.save!

  print '.'

  area
end

def create_user(params)
  defaults = {
    :password              => "#{params[:name].downcase}1234",
    :password_confirmation => "#{params[:name].downcase}1234",
    :inactive              => false,
    :province              => 'Vizcaya',
    :city                  => 'Ondarroa',
    :birthday              => rand(100).years.ago,
    :role                  => Role.find_by_name('Citizen'),
    :title                 => Title.find_by_name('Co-adviser')
  }
  params = defaults.merge(params)

  user = User.find_or_initialize_by_name_and_lastname_and_email(params[:name], params[:lastname], params[:email])
  user.password              = params[:password]
  user.password_confirmation = params[:password_confirmation]
  user.is_woman              = params[:is_woman]
  user.inactive              = params[:inactive]
  user.description           = params[:description_1] + params[:description_2] if params[:description_1] && params[:description_2]
  user.description_1         = params[:description_1]
  user.description_2         = params[:description_2]
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
  user.profile_picture = params[:profile_picture] if params[:profile_picture]
  user.users_following = params[:users_following] if params[:users_following]
  user.areas_following = params[:areas_following] if params[:areas_following]
  user.save!

  print '.'

  user
end

def create_proposal(params)

  proposal_data = ProposalData.find_or_initialize_by_title(params[:title])
  proposal_data.body = params[:body]
  proposal_data.image = params[:image]
  proposal_data.target_area = params[:target]

  proposal = Proposal.new
  proposal.tags = params[:tags]
  proposal.author = params[:author]
  proposal.proposal_data = proposal_data

  proposal.save!

  (params[:comments] || []).each do |comment|
    proposal.comments.create(comment)
  end

  print '.'

  proposal
end

def create_argument(params)

  argument = Argument.new
  argument.user = params[:author]
  argument.argument_data = ArgumentData.create :in_favor => params[:in_favor], :reason => params[:reason]
  argument.proposal = params[:proposal]

  argument.save!

  print '.'

  argument
end

def create_vote(params)

  vote = Vote.new
  vote.user = params[:author]
  vote.vote_data = VoteData.create :in_favor => params[:in_favor]

  case params[:proposal]
  when String
    vote.proposal = ProposalData.find_by_title(params[:proposal]).proposal
  when Integer
    vote.proposal = Proposal.find(params[:proposal])
  end

  vote.save!

  print '.'

  vote
end

def create_question(params)

  question_data = QuestionData.find_or_initialize_by_question_text(params[:text])
  case params[:for]
  when Area
    question_data.target_area = params[:for]
  when User
    question_data.target_user = params[:for]
  end

  question               = Question.new
  question.question_data = question_data
  question.tags          = params[:tags]
  question.author        = params[:author]

  question.save!

  (params[:want_an_answer] || []).each do |user|
    question.answer_requests.create :user => user
  end

  (params[:comments] || []).each do |comment|
    question.comments.create(comment)
  end

  if params[:answer]
    params[:answer][:question] = question.reload
    create_answer params[:answer]
  end

  print '.'

  question
end

def create_answer(params)

  answer = Answer.new
  answer.author = params[:author]
  answer.question = params[:question]

  answer_data = answer.build_answer_data
  answer_data.answer_text = params[:text]

  answer.save!

  (params[:comments] || []).each do |comment|
    answer.comments.create(comment)
  end

  print '.'

  answer
end

def create_event(params)
  defaults = {
    :latitude  => (-95..33).to_a.sample/10,
    :longitude => (360..438).to_a.sample/10
  }
  params = defaults.merge(params)

  event = Event.new
  event.author     = params[:user]
  event.location   = params[:location]
  event.latitude   = params[:latitude]
  event.longitude  = params[:longitude]
  event.tags       = params[:tags]
  event.event_data = EventData.create({
    :title      => params[:title],
    :subtitle   => params[:subtitle],
    :body       => params[:body],
    :event_date => params[:date],
    :image      => params[:image]
  })
  event.save!

  event.areas = params[:areas_tagged] || []
  event.users = params[:users_tagged] || []

  event.save!

  print '.'

  event
end

def create_news(params)

  news_data = NewsData.find_or_create_by_title(params[:title])

  news_data.subtitle = params[:subtitle]
  news_data.body     = params[:body]
  news_data.image    = Image.create :image => params[:image]
  news               = News.new
  news.news_data     = news_data
  news.tags          = params[:tags]
  news.author        = params[:author]
  news.save!

  news.areas         = params[:areas_tagged] if params[:areas_tagged]
  news.users         = params[:users_tagged] if params[:users_tagged]

  news.save!

  (params[:comments] || []).each do |comment|
    news.comments.create(comment)
  end

  print '.'

  news
end

def create_photo(params)

  image = Image.create :image => params[:image],
                       :title => params[:title],
                       :description => params[:description]

  photo = Photo.create :image    => image,
                       :tags     => params[:tags],
                       :author   => params[:author]

  (params[:comments] || []).each do |comment|
    photo.comments.create(comment)
  end

  print '.'

  photo
end

def create_tweet(params)
  defaults = {
    :status_id => '000000000000000000000'
  }
  params = defaults.merge(params)

  Tweet.create :author => params[:author],
               :tweet_data => TweetData.find_or_create_by_message(params[:message], :status_id => params[:status_id], :username => params[:username])

  print '.'

end

def create_status_message(params)

  StatusMessage.create :author => params[:author],
                       :status_message_data => StatusMessageData.find_or_create_by_message(params[:message])

  print '.'

end

def create_comment(user, comment = Faker::Lorem.sentence)
  {
    :user_id => user.id,
    :comment_data_attributes => {
      :body => comment
    }
  }
end

