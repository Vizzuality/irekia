require 'helper'

class TestFaker < Test::Unit::TestCase
  def test_numerify
    assert Faker.numerify('###').match(/\d{3}/)
  end

  def test_letterify
    assert Faker.letterify('???').match(/[a-z]{3}/)
  end

  def test_bothify
    assert Faker.bothify('???###').match(/[a-z]{3}\d{3}/)
  end
end
