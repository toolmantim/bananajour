require 'ostruct'

module DiffHelpers
  DIFF_INS  =  1
  DIFF_DEL  = -1
  DIFF_NOOP =  0

  def parse_diff(diff)
    raw_diff = diff.diff.split(/\n/)

    if diff.a_blob.nil?
      filename = diff.b_blob.name
      line_num = 1
      lines = diff.b_blob.data.split(/\n/).map do |line|
        line_num += 1
        OpenStruct.new(
          :body => line[0..-1],
          :op   => DIFF_INS,
           :num  => line_num - 1
         )
       end
     else
        filename = parse_filename(raw_diff[0..1])
        first_line_num = parse_first_line_num(raw_diff[2])
        lines = parse_lines(raw_diff[3..-1], first_line_num)
    end
    [filename, lines]
  end

  def diff_op_css_class(op)
    case op
    when DIFF_INS
      'code ins'
    when DIFF_DEL
      'code del'
    else
      'code unchanged unmod'
    end
  end

  private
    def parse_first_line_num(s)
      chunk_header_match = s.match(/^\@\@ ([+-]?\d+)(,([+-]?\d+))? ([+-]?\d+)(,([+-]?\d+))? \@\@$/)
      chunk_header_match[4].to_i.abs
    end

    def parse_filename(s)
      from = s[0].match(/^--- (.*)$/)[1]
      to = s[1].match(/^\+\+\+ (.*)$/)[1]
      from == '/dev/null' ? to[2..-1] : from[2..-1]
    end

    def parse_op(s)
      case s
      when '+'
        DIFF_INS
      when '-'
        DIFF_DEL
      else
        DIFF_NOOP
      end
    end

    def parse_lines(lines, start_line_num)
      op = prev_op = nil
      line_num = start_line_num
      run_length = 0

      lines.map { |line|
        prev_op = op
        op = parse_op(line[0, 1])

        if op != DIFF_NOOP
          if op == prev_op
            run_length += 1
          elsif prev_op != DIFF_NOOP
            line_num -= run_length
          end
        else
          run_length = 1
        end

        line_num += 1

        OpenStruct.new(
          :body => line[1..-1],
          :op   => op,
          :num  => line_num - 1
        )
      }
    end
end
