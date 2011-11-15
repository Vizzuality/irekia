module Footnotes
  class BeforeFilter
    # Method called to start the notes
    # It's a before filter prepend in the controller
    def self.filter(controller)
      Footnotes::Filter.start!(controller)
    end
  end

  class AfterFilter
    # Method that calls Footnotes to attach its contents
    def self.filter(controller)
      filter = Footnotes::Filter.new(controller)
      filter.add_footnotes!
      filter.close!(controller)
    end
  end

  class Filter
    @@no_style = false
    @@multiple_notes = false
    @@klasses = []

    # Default link prefix is textmate
    @@prefix = 'txmt://open?url=file://%s&amp;line=%d&amp;column=%d'

    # Edit notes
    @@notes = [ :controller, :view, :layout, :partials, :stylesheets, :javascripts ]
    # Show notes
    @@notes += [ :assigns, :session, :cookies, :params, :filters, :routes, :env, :queries, :log, :general ]

    # :no_style       => If you don't want the style to be appended to your pages
    # :notes          => Class variable that holds the notes to be processed
    # :prefix         => Prefix appended to FootnotesLinks
    # :multiple_notes => Set to true if you want to open several notes at the same time
    cattr_accessor :no_style, :notes, :prefix, :multiple_notes

    class << self

      # Calls the class method start! in each note
      # Sometimes notes need to set variables or clean the environment to work properly
      # This method allows this kind of setup
      #
      def start!(controller)
        self.each_with_rescue(Footnotes.before_hooks) {|hook| hook.call(controller, self)}

        @@klasses = []
        self.each_with_rescue(@@notes.flatten) do |note|
          klass = "Footnotes::Notes::#{note.to_s.camelize}Note".constantize
          klass.start!(controller) if klass.respond_to?(:start!)
          @@klasses << klass
        end
      end

      # Process notes, discarding only the note if any problem occurs
      #
      def each_with_rescue(collection)
        delete_me = []

        collection.each do |item|
          begin
            yield item
          rescue Exception => e
            # Discard item if it has a problem
            log_error("Footnotes #{item.to_s.camelize} Exception", e)
            delete_me << item
            next
          end
        end

        delete_me.each { |item| collection.delete(item) }
        return collection
      end

      # Logs the error using specified title and format
      #
      def log_error(title, exception)
        Rails.logger.error "#{title}: #{exception}\n#{exception.backtrace.join("\n")}"
      end

      # If none argument is sent, simply return the prefix.
      # Otherwise, replace the args in the prefix.
      #
      def prefix(*args)
        if args.empty?
          @@prefix
        else
          format(@@prefix, *args)
        end
      end

    end

    def initialize(controller)
      @controller = controller
      @template = controller.instance_variable_get(:@template)
      @body = controller.response.body
      @notes = []
    end

    def add_footnotes!
      add_footnotes_without_validation! if valid?
    rescue Exception => e
      # Discard footnotes if there are any problems
      self.class.log_error("Footnotes Exception", e)
    end

    # Calls the class method close! in each note
    # Sometimes notes need to finish their work even after being read
    # This method allows this kind of work
    #
    def close!(controller)
      self.each_with_rescue(@@klasses) {|klass| klass.close!(controller)}
      self.each_with_rescue(Footnotes.after_hooks) {|hook| hook.call(controller, self)}
    end

    protected
      def valid?
        performed_render? && valid_format? && valid_content_type? &&
          @body.is_a?(String) && !component_request? && !xhr? &&
          !footnotes_disabled?
      end

      def add_footnotes_without_validation!
        initialize_notes!
        insert_styles unless @@no_style
        insert_footnotes
      end

      def initialize_notes!
        each_with_rescue(@@klasses) do |klass|
          note = klass.new(@controller)
          @notes << note if note.respond_to?(:valid?) && note.valid?
        end
      end

      def performed_render?
        @controller.instance_variable_get(:@performed_render) || # rails 2.x
          (@controller.respond_to?(:performed?) && @controller.performed?) # rails3, will break on redirect??
      end

      def valid_format?
        if @template # Rails 2.x
          [:html,:rhtml,:xhtml,:rxhtml].include?(@template.send(template_format_method.to_sym).to_sym)
        else # Rails 3
          @controller.response.content_type == 'text/html'
        end
      end

      def template_format_method
        if @template.respond_to?(:template_format)
          return 'template_format'
        else
          return 'format'
        end
      end

      def valid_content_type?
        c = @controller.response.headers['Content-Type'].to_s
        (c.empty? || c =~ /html/)
      end

      def component_request?
        @controller.instance_variable_get(:@parent_controller)
      end

      def xhr?
        @controller.request.xhr?
      end

      def footnotes_disabled?
        @controller.params[:footnotes] == "false"
      end

      #
      # Insertion methods
      #

      def insert_styles
        #TODO More customizable(reset.css, from file etc.)
        insert_text :before, /<\/head>/i, <<-HTML
        <!-- Footnotes Style -->
        <style type="text/css">
          #footnotes_debug {font-size: 11px; font-weight: normal; margin: 2em 0 1em 0; text-align: center; color: #444; line-height: 16px;}
          #footnotes_debug th, #footnotes_debug td {color: #444; line-height: 18px;}
          #footnotes_debug a {color: #9b1b1b; font-weight: inherit; text-decoration: none; line-height: 18px;}
          #footnotes_debug table {text-align: center;}
          #footnotes_debug table td {padding: 0 5px;}
          #footnotes_debug tbody {text-align: left;}
          #footnotes_debug .name_values td {vertical-align: top;}
          #footnotes_debug legend {background-color: #fff;}
          #footnotes_debug fieldset {text-align: left; border: 1px dashed #aaa; padding: 0.5em 1em 1em 1em; margin: 1em 2em; color: #444; background-color: #FFF;}
          /* Aditional Stylesheets */
          #{@notes.map(&:stylesheet).compact.join("\n")}
        </style>
        <!-- End Footnotes Style -->
        HTML
      end

      def insert_footnotes
        # Fieldsets method should be called first
        content = fieldsets

        footnotes_html = <<-HTML
        <!-- Footnotes -->
        <div style="clear:both"></div>
        <div id="footnotes_debug">
          #{links}
          #{content}
          <script type="text/javascript">
            var Footnotes = function() {

              function hideAll(){
                #{close unless @@multiple_notes}
              }

              function hideAllAndToggle(id) {
                hideAll();
                toggle(id)

                location.href = '#footnotes_debug';
              }

              function toggle(id){
                var el = document.getElementById(id);
                if (el.style.display == 'none') {
                  Footnotes.show(el);
                } else {
                  Footnotes.hide(el);
                }
              }

              function show(element) {
                element.style.display = 'block'
              }

              function hide(element) {
                element.style.display = 'none'
              }

              return {
                show: show,
                hide: hide,
                toggle: toggle,
                hideAllAndToggle: hideAllAndToggle
              }
            }();
            /* Additional Javascript */
            #{@notes.map(&:javascript).compact.join("\n")}
          </script>
        </div>
        <!-- End Footnotes -->
        HTML

        placeholder = /<div[^>]+id=['"]footnotes_holder['"][^>]*>/i
        if @controller.response.body =~ placeholder
          insert_text :after, placeholder, footnotes_html
        else
          insert_text :before, /<\/body>/i, footnotes_html
        end
      end

      # Process notes to gets their links in their equivalent row
      #
      def links
        links = Hash.new([])
        order = []
        each_with_rescue(@notes) do |note|
          order << note.row
          links[note.row] += [link_helper(note)]
        end

        html = ''
        order.uniq!
        order.each do |row|
          html << "#{row.is_a?(String) ? row : row.to_s.camelize}: #{links[row].join(" | \n")}<br />"
        end
        html
      end

      # Process notes to get their content
      #
      def fieldsets
        content = ''
        each_with_rescue(@notes) do |note|
          next unless note.has_fieldset?
          content << <<-HTML
            <fieldset id="#{note.to_sym}_debug_info" style="display: none">
              <legend>#{note.legend}</legend>
              <div>#{note.content}</div>
            </fieldset>
          HTML
        end
        content
      end

      # Process notes to get javascript code to close them.
      # This method is only used when multiple_notes is false.
      #
      def close
        javascript = ''
        each_with_rescue(@notes) do |note|
          next unless note.has_fieldset?
          javascript << close_helper(note)
        end
        javascript
      end

      #
      # Helpers
      #

      # Helper that creates the javascript code to close the note
      #
      def close_helper(note)
        "Footnotes.hide(document.getElementById('#{note.to_sym}_debug_info'));\n"
      end

      # Helper that creates the link and javascript code when note is clicked
      #
      def link_helper(note)
        onclick = note.onclick
        unless href = note.link
          href = '#'
          onclick ||= "Footnotes.hideAllAndToggle('#{note.to_sym}_debug_info');return false;" if note.has_fieldset?
        end

        "<a href=\"#{href}\" onclick=\"#{onclick}\">#{note.title}</a>"
      end

      # Inserts text in to the body of the document
      # +pattern+ is a Regular expression which, when matched, will cause +new_text+
      # to be inserted before or after the match.  If no match is found, +new_text+ is appended
      # to the body instead. +position+ may be either :before or :after
      #
      def insert_text(position, pattern, new_text)
        index = case pattern
          when Regexp
            if match = @controller.response.body.match(pattern)
              match.offset(0)[position == :before ? 0 : 1]
            else
              @controller.response.body.size
            end
          else
            pattern
          end
        newbody = @controller.response.body
        newbody.insert index, new_text
        @controller.response.body = newbody
      end

      # Instance each_with_rescue method
      #
      def each_with_rescue(*args, &block)
        self.class.each_with_rescue(*args, &block)
      end

  end
end
