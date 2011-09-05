#encoding: UTF-8

module Factories

  def get_area_data
    validate_all_not_moderated

    Area.where(:name => 'Educación, Universidades e Investigación').first
  end

  def get_politic_data
    validate_all_not_moderated

    User.where(:name => 'Virginia Uriarte Rodríguez').first
  end

  def validate_all_not_moderated
    Content.validate_all_not_moderated
    Participation.validate_all_not_moderated
  end

  def create_similar_questions
    questions = [
      '¿Cuando vamos a recibir los nuevos planes de estudios de la ...?',
      'Hola Virginia, Sabes si hay algún sitio dónde se publiquen las becas de estudios universitarios'
    ]

    questions.each do |question_text|
      question = Question.new
      question.areas << Area.first
      question.users << User.find_by_name_and_email('María González Pérez', 'maria.gonzalez@gmail.com')
      question.question_data = QuestionData.find_or_initialize_by_question_text(question_text, :target_user => User.find_by_name_and_email('Alberto de Zárate López', 'alberto.zarate@ej-gv.es'))

      question.save!
    end
  end

end
RSpec.configure {|config| config.include Factories}