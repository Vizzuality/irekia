#encoding: UTF-8

require "spec_helper"

describe "Questions creation" do
  before do
    create_similar_questions
  end

  it "shows a list of similar questions to the one being created" do
    get questions_path(:query => 'Hola, ¿Cuando estáis pensando en actualizar la ley de acceso a becas de estudios universitarios?', :format => :json)

    response.body.should be == [
     {
                "author" => {
                       "id" => 7,
                     "name" => "María",
                 "fullname" => "María González Pérez",
            "profile_image" => "/uploads/image/image/6/thumb_woman.jpeg"
        },
          "published_at" => "2011-08-03T10:00:00Z",
         "question_text" => "Hola Virginia, Sabes si hay algún sitio dónde se publiquen las becas de estudios universitarios",
           "target_user" => nil,
           "answered_at" => nil,
        "comments_count" => 0
     },
     {
                "author" => {
                       "id" => 7,
                     "name" => "María",
                 "fullname" => "María González Pérez",
            "profile_image" => "/uploads/image/image/6/thumb_woman.jpeg"
        },
          "published_at" => "2011-08-03T10:00:10Z",
         "question_text" => "¿Cuándo va a ser efectiva la ayuda para estudiantes universitarios en 2011?",
           "target_user" => {
              "id" => 3,
            "name" => "Virginia Uriarte Rodríguez"
        },
           "answered_at" => nil,
        "comments_count" => 1
     },
     {
                "author" => {
                       "id" => 7,
                     "name" => "María",
                 "fullname" => "María González Pérez",
            "profile_image" => "/uploads/image/image/6/thumb_woman.jpeg"
        },
          "published_at" => "2011-08-03T10:00:10Z",
         "question_text" => "Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos.",
           "target_user" => nil,
           "answered_at" => "2011-08-03T10:00:10Z",
        "comments_count" => 0
     },
     {
                "author" => {
                       "id" => 7,
                     "name" => "María",
                 "fullname" => "María González Pérez",
            "profile_image" => "/uploads/image/image/6/thumb_woman.jpeg"
        },
          "published_at" => "2011-08-03T10:00:00Z",
         "question_text" => "¿Cuando vamos a recibir los nuevos planes de estudios de la ...?",
           "target_user" => nil,
           "answered_at" => nil,
        "comments_count" => 0
    }
    ].to_json
  end
end
