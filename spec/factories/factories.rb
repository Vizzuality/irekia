#encoding: UTF-8

module Factories

  def get_area_data
    Area.where(:name => 'Educación, Universidades e Investigación').first
  end

  def get_politic_data
    User.where(:name => 'Virginia', :lastname => 'Uriarte Rodríguez').first
  end

  def set_all_items_as_not_moderated
    %w(Content Participation).map(&:constantize).each do |item_type|
      item_type.moderated.find_each do |content|
        content.update_attribute('moderated', false)
      end
    end
  end

  def create_similar_questions
    questions = [
      '¿Cuando vamos a recibir los nuevos planes de estudios de la ...?',
      'Hola Virginia, Sabes si hay algún sitio dónde se publiquen las becas de estudios universitarios'
    ]

    questions.each do |question_text|
      question = Question.new
      question.areas << Area.first
      question.users << User.find_by_name_and_lastname_and_email('María', 'González Pérez', 'maria.gonzalez@gmail.com')
      question.question_data = QuestionData.find_or_initialize_by_question_text(question_text, :target_user => User.find_by_name_and_email('Alberto de Zárate López', 'alberto.zarate@ej-gv.es'))

      question.save!
    end
  end

end
RSpec.configure {|config| config.include Factories}
