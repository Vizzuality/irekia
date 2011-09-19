#encoding: UTF-8

require "spec_helper"

describe "Questions creation" do
  before do
    create_similar_questions
  end

  it "shows a list of similar questions to the one being created" do
    get questions_path(:query => 'Hola, ¿Cuando estáis pensando en actualizar la ley de acceso a becas de estudios universitarios?', :format => :json)

    questions = JSON.parse response.body

    questions.first['author']['fullname'].should be == 'María González Pérez'
    questions.first['question_text'].should be == 'Hola Virginia, Sabes si hay algún sitio dónde se publiquen las becas de estudios universitarios'
    questions.first['target_user'].should be_nil
    questions.first['answered_at'].should be_nil
    questions.first['comments_count'].should be 0

    questions.second['author']['fullname'].should be == 'María González Pérez'
    questions.second['question_text'].should be == '¿Cuándo va a ser efectiva la ayuda para estudiantes universitarios en 2011?'
    questions.second['target_user']['name'].should be == 'Virginia Uriarte Rodríguez'
    questions.second['answered_at'].should be_nil
    questions.second['comments_count'].should be 1

    questions.third['author']['fullname'].should be == 'María González Pérez'
    questions.third['question_text'].should be == 'Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos.'
    questions.third['target_user'].should be_nil
    questions.third['answered_at'].to_date.should be == Date.civil(2011, 8, 3)
    questions.third['comments_count'].should be 0


    questions.fourth['author']['fullname'].should be == 'María González Pérez'
    questions.fourth['question_text'].should be == '¿Cuando vamos a recibir los nuevos planes de estudios de la ...?'
    questions.fourth['target_user'].should be_nil
    questions.fourth['answered_at'].should be_nil
    questions.fourth['comments_count'].should be 0

  end
end
