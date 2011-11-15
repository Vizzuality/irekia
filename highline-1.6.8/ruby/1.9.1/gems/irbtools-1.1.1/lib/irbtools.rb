# encoding: utf-8

if defined?(IRB) || defined?(Ripl)
  # # # # #
  # require 'irbtools' in your .irbrc
  # see the README file for more information
  require File.expand_path('irbtools/configure', File.dirname(__FILE__) ) unless defined? Irbtools

  # # # # #
  # load extension packages
  Irbtools.packages.each{ |pkg|
    begin
      require "irbtools/#{pkg}"

    rescue LoadError => err
      warn "Couldn't load the extension package '#{pkg}' #{err.class}\n* " +
            err.message + "\n* " + err.backtrace[0] + "\n"
    end
  }

  # # # # #
  # loading helper proc
  load_libraries_proc = proc{ |libs|
    remember_verbose_and_debug = $VERBOSE, $DEBUG
    $VERBOSE = $DEBUG = false

    libs.each{ |lib|
      begin
        require lib.to_s
        Irbtools.send :library_loaded, lib
      rescue Exception => err
        warn "Couldn't load the irb library '#{lib}': #{err.class}\n* " +
             err.message + "\n* " + err.backtrace[0] + "\n"
      end
    }
    $VERBOSE, $DEBUG = remember_verbose_and_debug
  }

  # # # # #
  # load: start
  load_libraries_proc[ Irbtools.libraries[:start] ]

  # # # # #
  # load: autoload
  Irbtools.libraries[:autoload].each{ |constant, lib_name, gem_name|
    gem gem_name
    autoload constant, lib_name
    Irbtools.send :library_loaded, lib_name
  }

  # # # # #
  # irb options
  unless defined?(Ripl) && Ripl.respond_to?(:started?) && Ripl.started?
    IRB.conf[:AUTO_INDENT]  = true                 # simple auto indent
    IRB.conf[:EVAL_HISTORY] = 42424242424242424242 # creates the special __ variable
    IRB.conf[:SAVE_HISTORY] = 2000                 # how many lines will go to ~/.irb_history

    # prompt
    (IRB.conf[:PROMPT] ||= {} ).merge!( {:IRBTOOLS => {
      :PROMPT_I => ">> ",    # normal
      :PROMPT_N => "|  ",    # indenting
      :PROMPT_C => " > ",    # continuing a statement
      :PROMPT_S => "%l> ",   # continuing a string
      :RETURN   => "=> %s \n",
      :AUTO_INDENT => true,
    }})

    IRB.conf[:PROMPT_MODE] = :IRBTOOLS
  end

  # # # # #
  # misc: add current directory to the load path
  $: << '.'  if RUBY_VERSION >= '1.9.2'

  # # # # #
  # load: rails.rc
  begin
    if  ( ENV['RAILS_ENV'] || defined? Rails ) && Irbtools.railsrc &&
        File.exist?( File.expand_path(Irbtools.railsrc) )
      load File.expand_path(Irbtools.railsrc)
    end
  rescue
  end

  # # # # #
  # load: sub-session / after_rc
  if defined?(Ripl) && Ripl.respond_to?(:started?) && Ripl.started?
    if defined? Ripl::AfterRc
      Irbtools.libraries[:sub_session].each{ |r| Ripl.after_rcs << r }
    elsif !Irbtools.libraries[:sub_session].empty?
      warn "Couldn't load libraries in Irbtools.libraries[:sub_session]. Please install ripl-after_rc to use this feature in Ripl!"
    end
  else
    original_irbrc_proc = IRB.conf[:IRB_RC]
    IRB.conf[:IRB_RC] = proc{
      load_libraries_proc[ Irbtools.libraries[:sub_session] ]
      original_irbrc_proc[ ]  if original_irbrc_proc
    }
  end

  # # # # #
  # load: threads
  Irbtools.libraries[:thread].each{ |_,libs|
    Thread.new do
      load_libraries_proc[ libs ]
    end
  }

  # # # # #
  # load: late
  load_libraries_proc[ Irbtools.libraries[:late] ]

  # # # # #
  # load: late_threads
  Irbtools.libraries[:late_thread].each{ |_,libs|
    Thread.new do
      load_libraries_proc[ libs ]
    end
  }

  # # # # #
  # done :)
  if msg = Irbtools.welcome_message
    puts msg
  end
end

# J-_-L
