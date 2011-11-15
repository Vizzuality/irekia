require 'helper'

class TestLorem < Test::Unit::TestCase

  def test_paragraph
    assert_match /[ a-z]+/, Faker::Lorem.paragraph
  end

  def test_sentence
    assert_match /[ a-z]+/, Faker::Lorem.sentence
  end

  def test_paragraphs
    assert_match /[ a-z]+/, Faker::Lorem.paragraphs.join(" ")
  end

  def test_sentences
    assert_match /[ a-z]+/, Faker::Lorem.sentences.join(" ")
  end

  def test_words
    assert_match /[ a-z]+/, Faker::Lorem.words.join(" ")
  end

  def test_word
    assert_match /[a-z]+/, Faker::Lorem.word
  end
end
