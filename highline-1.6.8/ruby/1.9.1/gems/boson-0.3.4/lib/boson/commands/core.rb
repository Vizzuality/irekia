module Boson::Commands::Core #:nodoc:
  extend self

  def config
    command_attributes = Boson::Command::ATTRIBUTES + [:usage, :full_name, :render_options]
    library_attributes = Boson::Library::ATTRIBUTES + [:library_type]

    commands = {
      'render'=>{:desc=>"Render any object using Hirb"},
      'menu'=>{:desc=>"Provide a menu to multi-select elements from a given array"},
      'usage'=>{:desc=>"Print a command's usage", :options=>{
        :verbose=>{:desc=>"Display global options", :type=>:boolean},
        :render_options=>{:desc=>"Render options for option tables", :default=>{},
          :keys=>[:vertical, :fields, :hide_empty]} } },
      'commands'=>{
        :desc=>"List or search commands. Query must come before any options.", :default_option=>'query',
        :options=>{ :index=>{:type=>:boolean, :desc=>"Searches index"},
          :local=>{:type=>:boolean, :desc=>"Local commands only" } },
        :render_options=>{
          [:headers,:H]=>{:default=>{:desc=>'description'}},
          :query=>{:keys=>command_attributes, :default_keys=>'full_name'},
          :fields=>{:default=>[:full_name, :lib, :alias, :usage, :desc], :values=>command_attributes, :enum=>false},
          :filters=>{:default=>{:render_options=>:inspect, :options=>:inspect, :args=>:inspect, :config=>:inspect}}
        }
      },
      'libraries'=>{
        :desc=>"List or search libraries. Query must come before any options.", :default_option=>'query',
        :options=>{ :index=>{:type=>:boolean, :desc=>"Searches index"},
          :local=>{:type=>:boolean, :desc=>"Local libraries only" } },
        :render_options=>{
          :query=>{:keys=>library_attributes, :default_keys=>'name'},
          :fields=>{:default=>[:name, :commands, :gems, :library_type], :values=>library_attributes, :enum=>false},
          :filters=>{:default=>{:gems=>[:join, ','],:commands=>:size}, :desc=>"Filters to apply to library fields" }}
      },
      'load_library'=>{:desc=>"Load a library", :options=>{[:verbose,:V]=>true}}
    }

    {:namespace=>false, :library_file=>File.expand_path(__FILE__), :commands=>commands}
  end

  def commands(options={})
    cmds = options[:index] ? (Boson::Index.read || true) && Boson::Index.commands : Boson.commands
    options[:local] ? cmds.select {|e| e.library && e.library.local? } : cmds
  end

  def libraries(options={})
    libs = options[:index] ? (Boson::Index.read || true) && Boson::Index.libraries : Boson.libraries
    options[:local] ? libs.select {|e| e.local? } : libs
  end

  def load_library(library, options={})
    Boson::Manager.load(library, options)
  end

  def render(object, options={})
    Boson::View.render(object, options)
  end

  def menu(arr, options={}, &block)
    Hirb::Console.format_output(arr, options.merge(:class=>"Hirb::Menu"), &block)
  end

  def usage(command, options={})
    puts Boson::Command.usage(command)

    if (cmd = Boson::Command.find(command))
      if cmd.options && !cmd.options.empty?
        puts "\nLOCAL OPTIONS"
        cmd.option_parser.print_usage_table options[:render_options].dup.merge(:local=>true)
      end
      if options[:verbose] && cmd.render_option_parser
        puts "\nGLOBAL OPTIONS"
        cmd.render_option_parser.print_usage_table options[:render_options].dup
      end
    end
  end
end