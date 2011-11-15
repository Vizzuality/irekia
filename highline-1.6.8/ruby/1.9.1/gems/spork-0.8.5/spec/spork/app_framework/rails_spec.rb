require File.dirname(__FILE__) + '/../../spec_helper'

describe Spork::AppFramework::Rails do
  describe ".version" do
    it "detects the current version of rails" do
      create_file("config/environment.rb", "RAILS_GEM_VERSION = '2.1.0'")
      in_current_dir do
        Spork::AppFramework::Rails.new.version.should == "2.1.0"
      end
      
      create_file("config/environment.rb", 'RAILS_GEM_VERSION = "2.1.0"')
      in_current_dir do
        Spork::AppFramework::Rails.new.version.should == "2.1.0"
      end
      
      create_file("config/environment.rb", 'RAILS_GEM_VERSION = "> 2.1.0"')
      in_current_dir do
        Spork::AppFramework::Rails.new.version.should == "> 2.1.0"
      end
    end
  end
end
