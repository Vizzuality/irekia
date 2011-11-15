require File.join(File.dirname(__FILE__), 'test_helper')

describe "RepoIndex" do
  # since we're defining our own @commands, @libraries, @lib_hashes
  def index
    @index ||= begin
      ind = RepoIndex.new(Boson.repo)
      ind.instance_variable_set "@read", true
      ind
    end
  end

  describe "read_and_transfer" do
    before { reset_boson; index.instance_eval "@libraries = @commands = nil" }

    def transfers(options={})
      index.instance_variable_set "@libraries", [Library.new(:name=>'blah', :commands=>['blurb']),
        Library.new(:name=>'bling')]
      index.instance_variable_set "@commands", [Command.new(:name=>'blurb', :lib=>'blah')]
      index.read_and_transfer options[:ignored] || []
      Boson.libraries.map {|e| e.name}.should == options[:libraries]
      Boson.commands.map {|e| e.name}.should == options[:commands]
    end

    it "transfers libraries with no libraries to ignore" do
      transfers :libraries=>%w{blah bling}, :commands=>%w{blurb}, :ignored=>[]
    end

    it "transfers libraries and commands except for ignored libraries and its commands" do
      transfers :libraries=>%w{bling}, :commands=>[], :ignored=>%w{blah}
    end

    it "doesn't replace existing libraries" do
      lib = Library.new(:name=>'blah')
      cmd = Command.new(:name=>'blurb', :lib=>'blah')
      Boson.libraries << lib
      Boson.commands << cmd
      transfers :libraries=>%w{blah bling}, :commands=>%w{blurb}
      Boson.libraries.include?(lib).should == true
      Boson.commands.include?(cmd).should == true
    end
  end

  describe "find_library" do
    before_all {
      reset_boson
      commands = [Command.new(:name=>'blurb', :lib=>'blah', :alias=>'bb'), 
        Command.new(:name=>'sub', :lib=>'bling', :alias=>'s')
      ]
      index.instance_variable_set "@commands", commands
      index.instance_variable_set "@libraries", [Library.new(:name=>'blah'), Library.new(:name=>'bling', :namespace=>'bling')]
    }

    it "finds command aliased or not" do
      index.find_library('blurb').should == 'blah'
      index.find_library('bb').should == 'blah'
    end

    it "doesn't find command" do
      index.find_library('blah').should == nil
    end

    it "finds a subcommand aliased or not" do
      index.find_library('bling.sub').should == 'bling'
      # @index.find_library('bl.s').should == 'bling'
    end

    it "finds namespace command aliased or not without a subcommand" do
      index.find_library('bling').should == 'bling'
      # @index.find_library('bl').should == 'bling'
    end

    it "doesn't find a subcommand" do
      index.find_library('d.d').should == nil
    end
  end

  describe "changed_libraries" do
    before_all { index.instance_eval "@lib_hashes = nil" }

    def changed(string, all_libs=['file1'])
      index.repo.expects(:all_libraries).returns(all_libs)
      index.instance_variable_set "@lib_hashes", {"file1"=>Digest::MD5.hexdigest("state1")}
      File.stubs(:exists?).returns(true)
      File.expects(:read).returns(string)
      index.changed_libraries
    end

    it "detects changed libraries" do
      changed("state2").should == %w{file1}
    end

    it "detects new libraries" do
      changed("state1", ['file2']).should == %w{file2}
    end

    it "detects no changed libraries" do
      changed("state1").should == []
    end
  end

  describe "write" do
    before_all {
      reset_boson
      Boson.commands << Command.new(:name=>'blah', :lib=>'blah', :args=>[['arg1', {}], ['arg2', self.class]])
      Boson.libraries << Library.new(:name=>'blah', :module=>self.class)
      index.expects(:latest_hashes)
      libraries = commands = []
      index.expects(:save_marshal_index).with {|str| libraries, commands, hashes = Marshal.load(str) ; true}
      index.write
      @index_hash = {:libraries=>libraries, :commands=>commands}
    }

    it "saves library module constants as strings" do
      @index_hash[:libraries][0].module.class.should == String
    end

    it "save commands with arg values as strings" do
      @index_hash[:commands][0].args.each {|e| e[1].class.should == String}
    end
  end
end