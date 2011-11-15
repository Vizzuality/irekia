module CodeRay
module Encoders

  class HTML

    module Numbering  # :nodoc:

      def self.number! output, mode = :table, options = {}
        return self unless mode

        options = DEFAULT_OPTIONS.merge options

        start = options[:line_number_start]
        unless start.is_a? Integer
          raise ArgumentError, "Invalid value %p for :line_number_start; Integer expected." % start
        end
        
        anchor_prefix = options[:line_number_anchors]
        anchor_prefix = 'line' if anchor_prefix == true
        anchor_prefix = anchor_prefix.to_s[/\w+/] if anchor_prefix
        anchoring =
          if anchor_prefix
            proc do |line|
              line = line.to_s
              anchor = anchor_prefix + line
              "<a href=\"##{anchor}\" name=\"#{anchor}\">#{line}</a>"
            end
          else
            proc { |line| line.to_s }  # :to_s.to_proc in Ruby 1.8.7+
          end
        
        bold_every = options[:bold_every]
        highlight_lines = options[:highlight_lines]
        bolding =
          if bold_every == false && highlight_lines == nil
            anchoring
          elsif highlight_lines.is_a? Enumerable
            highlight_lines = highlight_lines.to_set
            proc do |line|
              if highlight_lines.include? line
                "<strong class=\"highlighted\">#{anchoring[line]}</strong>"  # highlighted line numbers in bold
              else
                anchoring[line]
              end
            end
          elsif bold_every.is_a? Integer
            raise ArgumentError, ":bolding can't be 0." if bold_every == 0
            proc do |line|
              if line % bold_every == 0
                "<strong>#{anchoring[line]}</strong>"  # every bold_every-th number in bold
              else
                anchoring[line]
              end
            end
          else
            raise ArgumentError, 'Invalid value %p for :bolding; false or Integer expected.' % bold_every
          end
        
        line_count = output.count("\n")
        position_of_last_newline = output.rindex(RUBY_VERSION >= '1.9' ? /\n/ : ?\n)
        if position_of_last_newline
          after_last_newline = output[position_of_last_newline + 1 .. -1]
          ends_with_newline = after_last_newline[/\A(?:<\/span>)*\z/]
          line_count += 1 if not ends_with_newline
        end
        
        case mode
        when :inline
          max_width = (start + line_count).to_s.size
          line_number = start
          nesting = []
          output.gsub!(/^.*$\n?/) do |line|
            line.chomp!
            open = nesting.join
            line.scan(%r!<(/)?span[^>]*>?!) do |close,|
              if close
                nesting.pop
              else
                nesting << $&
              end
            end
            close = '</span>' * nesting.size
            
            line_number_text = bolding.call line_number
            indent = ' ' * (max_width - line_number.to_s.size)  # TODO: Optimize (10^x)
            line_number += 1
            "<span class=\"line-numbers\">#{indent}#{line_number_text}</span>#{open}#{line}#{close}\n"
          end

        when :table
          line_numbers = (start ... start + line_count).map(&bolding).join("\n")
          line_numbers << "\n"
          line_numbers_table_template = Output::TABLE.apply('LINE_NUMBERS', line_numbers)

          output.gsub!(/<\/div>\n/, '</div>')
          output.wrap_in! line_numbers_table_template
          output.wrapped_in = :div

        when :list
          raise NotImplementedError, 'The :list option is no longer available. Use :table.'

        else
          raise ArgumentError, 'Unknown value %p for mode: expected one of %p' %
            [mode, [:table, :inline]]
        end

        output
      end

    end

  end

end
end
