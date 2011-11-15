require 'spec_helper'
require "rails-footnotes/notes/javascripts_note"

describe Footnotes::Notes::JavascriptsNote do
  let(:note) {described_class.new(mock('controller', :response => mock('body', :body => '')))}
  subject {note}

  it {should be_valid}

  it "should return js links from html after #scan_text mehtod call" do
    subject.send(:scan_text, HTML_WITH_JS).should eql ['/javascripts/all.js', '/javascripts/jquery.js']
  end
end

HTML_WITH_JS = <<-EOF
  <script cache="false" src="/javascripts/all.js?1315913920" type="text/javascript"></script>
  <script cache="false" src="/javascripts/jquery.js?1315913920" type="text/javascript"></script>
EOF
