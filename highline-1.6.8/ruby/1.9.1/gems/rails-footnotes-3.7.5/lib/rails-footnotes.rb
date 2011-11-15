module Footnotes
  mattr_accessor :before_hooks
  @@before_hooks = []

  mattr_accessor :after_hooks
  @@after_hooks = []

  def self.before(&block)
    @@before_hooks << block
  end

  def self.after(&block)
    @@after_hooks << block
  end

  # The footnotes are applied by default to all actions. You can change this
  # behavior commenting the after_filter line below and putting it in Your
  # application. Then you can cherrypick in which actions it will appear.
  #
  module RailsFootnotesExtension
    def self.included(base)
      base.prepend_before_filter Footnotes::BeforeFilter
      base.after_filter Footnotes::AfterFilter
    end
  end

  def self.run!
    require 'rails-footnotes/footnotes'
    require 'rails-footnotes/backtracer'
    require 'rails-footnotes/abstract_note'
    require 'rails-footnotes/notes/all'

    ActionController::Base.send(:include, RailsFootnotesExtension)

    load Rails.root.join('.rails_footnotes') if Rails.root.join('.rails_footnotes').exist?
    #TODO DEPRECATED
    load Rails.root.join('.footnotes') if Rails.root.join('.footnotes').exist?
  end

  def self.setup
    yield self
  end
end
