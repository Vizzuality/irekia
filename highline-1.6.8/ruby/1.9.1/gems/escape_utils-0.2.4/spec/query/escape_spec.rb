require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe EscapeUtils, "escape_url" do
  it "should respond to escape_url" do
    EscapeUtils.should respond_to(:escape_url)
  end

  it "should escape a basic url" do
    EscapeUtils.escape_url("http://www.homerun.com/").should eql("http%3A%2F%2Fwww.homerun.com%2F")
  end

  # NOTE: from Rack's test suite
  it "should escape a url containing tags" do
    EscapeUtils.escape_url("fo<o>bar").should eql("fo%3Co%3Ebar")
  end

  # NOTE: from Rack's test suite
  it "should escape a url with spaces" do
    EscapeUtils.escape_url("a space").should eql("a+space")
    EscapeUtils.escape_url("a   sp ace ").should eql("a+++sp+ace+")
  end

  # NOTE: from Rack's test suite
  it "should escape a string of mixed characters" do
    EscapeUtils.escape_url("q1!2\"'w$5&7/z8)?\\").should eql("q1%212%22%27w%245%267%2Fz8%29%3F%5C")
  end

  # NOTE: from Rack's test suite
  it "should escape correctly for multibyte characters" do
    matz_name = "\xE3\x81\xBE\xE3\x81\xA4\xE3\x82\x82\xE3\x81\xA8" # Matsumoto
    EscapeUtils.escape_url(matz_name).should eql('%E3%81%BE%E3%81%A4%E3%82%82%E3%81%A8')
    matz_name_sep = "\xE3\x81\xBE\xE3\x81\xA4 \xE3\x82\x82\xE3\x81\xA8" # Matsu moto
    EscapeUtils.escape_url(matz_name_sep).should eql('%E3%81%BE%E3%81%A4+%E3%82%82%E3%81%A8')
  end

  if RUBY_VERSION =~ /^1.9/
    it "return value should be in original string's encoding" do
      str = "http://www.homerun.com/".encode('us-ascii')
      EscapeUtils.escape_url(str).encoding.should eql(Encoding.find('us-ascii'))
      str = "http://www.homerun.com/".encode('utf-8')
      EscapeUtils.escape_url(str).encoding.should eql(Encoding.find('utf-8'))
    end
  end
end