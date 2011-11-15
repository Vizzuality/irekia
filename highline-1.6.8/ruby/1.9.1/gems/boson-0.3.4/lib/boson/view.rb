module Boson
  # This module generates views for a command by handing it to {Hirb}[http://tagaholic.me/hirb/]. Since Hirb can be customized
  # to generate any view, commands can have any views associated with them!
  #
  # === Views with Render Options
  # To pass rendering options to a Hirb helper as command options, a command has to define the options with
  # the render_options method attribute:
  #
  #   # @render_options :fields=>[:a,:b]
  #   def list(options={})
  #     [{:a=>1, :b=>2}, {:a=>10,:b=>11}]
  #   end
  #
  #   # To see that the render_options method attribute actually passes the :fields option by default:
  #   >> list '-p'   # or list '--pretend'
  #   Arguments: []
  #   Global options: {:pretend=>true, :fields=>[:a, :b]}
  #
  #   >> list
  #   +----+----+
  #   | a  | b  |
  #   +----+----+
  #   | 1  | 2  |
  #   | 10 | 11 |
  #   +----+----+
  #   2 rows in set
  #
  #   # To create a vertical table, we can pass --vertical, one of the default global render options.
  #   >> list '-V'   # or list '--vertical'
  #   *** 1. row ***
  #   a: 1
  #   b: 2
  #   ...
  #
  #   # To get the original return value use the global option --render
  #   >> list '-r'  # or list '--render'
  #   => [{:a=>1, :b=>2}, {:a=>10,:b=>11}]
  #
  # === Boson and Hirb
  # Since Boson uses {Hirb's auto table helper}[http://tagaholic.me/hirb/doc/classes/Hirb/Helpers/AutoTable.html]
  # by default, you may want to read up on its many options. To use any of them in commands, define them locally
  # with render_options or globally by adding them under the :render_options key of the main config.
  # What if you want to use your own helper class? No problem. Simply pass it with the global :class option.
  #
  # When using the default helper, one of the most important options to define is :fields. Aside from controlling what fields
  # are displayed, it's used to set :values option attributes for related options i.e. :sort and :query. This provides handy option
  # value aliasing via OptionParser. If you don't set :fields, Boson will try to set its :values with field-related options i.e.
  # :change_fields, :filters and :headers.
  module View
    extend self

    # Enables hirb and reads a config file from the main repo's config/hirb.yml.
    def enable
      unless @enabled
        Hirb::View.enable(:config_file=>File.join(Boson.repo.config_dir, 'hirb.yml'))
        Hirb::Helpers::Table.filter_any = true
      end
      @enabled = true
    end

    # Renders any object via Hirb. Options are passed directly to
    # {Hirb::Console.render_output}[http://tagaholic.me/hirb/doc/classes/Hirb/Console.html#M000011].
    def render(object, options={}, return_obj=false)
      if options[:inspect]
        puts(object.inspect)
      else
        render_object(object, options, return_obj) unless silent_object?(object)
      end
    end

    #:stopdoc:
    def class_config(klass)
      opts = (Hirb::View.formatter_config[klass] || {}).dup
      opts.delete(:ancestor)
      opts.merge!((opts.delete(:options) || {}).dup)
      OptionParser.make_mergeable!(opts)
      opts
    end

    def toggle_pager
      Hirb::View.toggle_pager
    end

    def silent_object?(obj)
      [nil,false,true].include?(obj)
    end

    def render_object(object, options={}, return_obj=false)
      options[:class] ||= :auto_table
      render_result = Hirb::Console.render_output(object, options)
      return_obj ? object : render_result
    end
    #:startdoc:
  end
end
