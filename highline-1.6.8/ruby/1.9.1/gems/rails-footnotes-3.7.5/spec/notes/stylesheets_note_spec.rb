require 'spec_helper'
require "rails-footnotes/notes/stylesheets_note"

describe Footnotes::Notes::StylesheetsNote do

  let(:note) {described_class.new(mock('controller', :response => mock('body', :body => '')))}
  subject {note}

  it {should be_valid}

  it "should return css link from html text after #scan_text call" do
    subject.send(:scan_text, HTML_WITH_CSS).should eql ['/stylesheets/compiled/print.css', '/stylesheets/compiled/print.css']
  end
end

HTML_WITH_CSS = <<-EOF
  <link href="/stylesheets/compiled/print.css?1315913920" media="print" rel="stylesheet" type="text/css" />'
  '<link href="/stylesheets/compiled/print.css?1315913920" media="print" rel="stylesheet" type="text/css" />'
EOF
