require "spec_helper"
require 'action_controller'
require "rails-footnotes/notes/assigns_note"

describe Footnotes::Notes::AssignsNote do
  let(:note) do
    @controller = mock
    @controller.stub(:instance_variables).and_return([:@action_has_layout, :@_status])
    @controller.instance_variable_set(:@action_has_layout, true)
    @controller.instance_variable_set(:@_status, 200)
    Footnotes::Notes::AssignsNote.new(@controller)
  end
  subject {note}

  before(:each) {Footnotes::Notes::AssignsNote.ignored_assigns = []}

  it {should be_valid}
  its(:title) {should eql 'Assigns (2)'}

  specify {note.send(:assigns).should eql [:@action_has_layout, :@_status]}
  specify {note.send(:to_table).should eql [['Name', 'Value'], [:@action_has_layout, "true"], [:@_status, "200"]]}

  describe "Ignored Assigns" do
    before(:each) {Footnotes::Notes::AssignsNote.ignored_assigns = [:@_status]}
    it {note.send(:assigns).should_not include :@_status}
  end

  it "should call #mount_table method with correct params" do
    note.should_receive(:mount_table).with(
      [['Name', 'Value'], [:@action_has_layout, "true"], [:@_status, "200"]], {:summary=>"Debug information for Assigns (2)"})
    note.content
  end
end
