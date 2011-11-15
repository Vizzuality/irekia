module Footnotes
  module Notes
    class QueriesNote < AbstractNote
      cattr_accessor :alert_db_time, :alert_sql_number, :orm, :ignored_regexps, :instance_writter => false
      @@alert_db_time    = 16.0
      @@alert_sql_number = 8
      @@query_subscriber = nil
      @@orm              = [:active_record, :data_mapper]
      @@ignored_regexps  = [%r{(pg_table|pg_attribute|show\stables|pragma|sqlite_master)}i]

      def self.start!(controller)
        self.query_subscriber.reset!
      end

      def self.query_subscriber
        @@query_subscriber ||= Footnotes::Notes::QuerySubscriber.new(self.orm)
      end

      def events
        self.class.query_subscriber.events
      end

      def title
        queries = self.events.count
        total_time = self.events.map(&:duration).sum / 1000.0
        query_color = generate_red_color(self.events.count, alert_sql_number)
        db_color    = generate_red_color(total_time, alert_db_time)

        <<-TITLE
        <span style="background-color:#{query_color}">Queries (#{queries})</span>
        <span style="background-color:#{db_color}">DB (#{"%.3f" % total_time}ms)</span>
        TITLE
      end

      def content
        html = ''
        self.events.each_with_index do |event, index|
          sql_links = []
          sql_links << "<a href=\"javascript:Footnotes.toggle('qtrace_#{index}')\" style=\"color:#00A;\">trace</a>"

          html << <<-HTML
            <b id="qtitle_#{index}">#{escape(event.type.to_s.upcase)}</b> (#{sql_links.join(' | ')})<br />
            <span id="sql_#{index}">#{print_query(event.payload[:sql])}</span><br />
            #{print_name_and_time(event.payload[:name], event.duration / 1000.0)}&nbsp;
            <p id="qtrace_#{index}" style="display:none;">#{parse_trace(event.trace)}</p><br />
          HTML
        end
        return html
      end

      protected
      def print_name_and_time(name, time)
        "<span style='background-color:#{generate_red_color(time, alert_ratio)}'>#{escape(name || 'SQL')} (#{'%.3fms' % time})</span>"
      end

      def print_query(query)
        escape(query.to_s.gsub(/(\s)+/, ' ').gsub('`', ''))
      end

      def generate_red_color(value, alert)
        c = ((value.to_f/alert).to_i - 1) * 16
        c = 0  if c < 0; c = 15 if c > 15; c = (15-c).to_s(16)
        "#ff#{c*4}"
      end

      def alert_ratio
        alert_db_time / alert_sql_number
      end

      def parse_trace(trace)
        trace.map do |t|
          s = t.split(':')
          %[<a href="#{escape(Footnotes::Filter.prefix("#{Rails.root.to_s}/#{s[0]}", s[1].to_i, 1))}">#{escape(t)}</a><br />]
        end.join
      end
    end

    class QuerySubscriberNotifactionEvent
      attr_reader :event, :trace, :query
      delegate :name, :payload, :duration, :time, :type, :to => :event

      def initialize(event, ctrace)
        @event, @ctrace, @query = event, ctrace, event.payload[:sql]
      end

      def trace
        @trace ||= @ctrace.collect(&:strip).select{|i| i.gsub!(/^#{Rails.root.to_s}\//, '') } || []
      end

      def type
        @type ||= self.query.match(/^(\s*)(select|insert|update|delete|alter)\b/im) || 'Unknown'
      end
    end

    class QuerySubscriber < ActiveSupport::LogSubscriber
      attr_accessor :events, :ignore_regexps

      def initialize(orm)
        @events = []
        orm.each {|adapter| ActiveSupport::LogSubscriber.attach_to adapter, self}
      end

      def reset!
        self.events.clear
      end

      def sql(event)
        unless QueriesNote.ignored_regexps.any? {|rex| event.payload[:sql] =~ rex }
          @events << QuerySubscriberNotifactionEvent.new(event.dup, caller)
        end
      end
    end
  end
end
