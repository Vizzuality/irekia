require "active_record"
require "active_support/concern"

module PgSearch
  extend ActiveSupport::Concern

  module ClassMethods
    def pg_search_scope(name, options)
      self.scope(
        name,
        PgSearch::Scope.new(name, self, options).to_proc
      )
    end

    def multisearchable(options = {})
      include PgSearch::Multisearchable
      class_attribute :pg_search_multisearchable_options
      self.pg_search_multisearchable_options = options
    end
  end

  module InstanceMethods
    def rank
      attributes['pg_search_rank'].to_f
    end
  end

  class << self
    def multisearch(query)
      PgSearch::Document.search(query)
    end

    def disable_multisearch
      Thread.current["PgSearch.enable_multisearch"] = false
      yield
    ensure
      Thread.current["PgSearch.enable_multisearch"] = true
    end

    def multisearch_enabled?
      Thread.current.key?("PgSearch.enable_multisearch") ? Thread.current["PgSearch.enable_multisearch"] : true
    end
  end

  class NotSupportedForPostgresqlVersion < StandardError; end
end

require "pg_search/configuration"
require "pg_search/document"
require "pg_search/features"
require "pg_search/multisearch"
require "pg_search/multisearchable"
require "pg_search/normalizer"
require "pg_search/scope"
require "pg_search/scope_options"
require "pg_search/version"

require "pg_search/railtie" if defined?(Rails)
