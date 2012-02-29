def root_path
  '/'
end

def area_path(area)
  "/es/areas/#{area.slug_es}"
end

def politician_path(politician)
  "/es/politicos/#{politician.slug}"
end

def news_path(news)
  "/es/noticias/#{news.slug}"
end

def event_path(event)
  "/es/eventos/#{event.slug}"
end

def question_path(question)
  "/es/preguntas/#{question.slug}"
end

def proposal_path(proposal)
  "/es/propuestas/#{proposal.slug}"
end

def photo_path(photo)
  "/es/fotos/#{photo.slug}"
end

def tweet_path(tweet)
  "/es/tweets/#{tweet.slug}"
end

def status_message_path(status_message)
  "/es/cambios_de_estado/#{status_message.slug}"
end

def search_path
  '/es/buscar'
end
