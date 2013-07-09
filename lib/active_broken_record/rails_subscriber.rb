module ActiveBrokenRecord

  class RailsSubscriber

    def initialize()
      @show_duplicate_notifications = false
      @show_bulk_load_opportunities = false
    end

    def callback(name)
      method("#{name}_callback")
    end

    def finish_recording_callback(*_)
      visited.clear
      callers.clear
      notified.clear
      @recording = false
    end

    def start_recording_callback(*_)
      @recording = true
    end

    def sql_callback(*args)
      return unless @recording

      opts          = args.extract_options!
      sql           = opts[:sql]
      name          = opts[:name]

      return if sql =~ /BEGIN|COMMIT|ROLLBACK/ || name =~ /SCHEMA/

      parameterised = parameterise(sql)

      if visited.include?(sql) && name == 'CACHE'
        notify "Duplicate Query", sql, caller
      elsif visited.include?(parameterised) && @show_bulk_load_opportunities
        notify "Possible candidate for bulk load", parameterised, caller
      else
        visit sql, caller
        visit parameterised, caller if @show_bulk_load_opportunities
      end
    end

    def parameterise(sql)
      sql.gsub(/`\s*=\s*(\d+)/, '={\d}')
    end

    def visited
      @visited ||= Set.new
    end

    def callers
      @callers ||= {}
    end

    def notified
      @notified ||= Set.new
    end

    def visit(sql, caller)
      visited << sql
      callers[sql] = caller
    end

    def notify(message, sql, caller)
      return if notified.include? sql

      current_caller = strip_backtrace caller
      old_caller     = strip_backtrace callers[sql]

      output = []

      output << "<<BROKEN RECORD>> #{message}: #{sql}"

      diverge_index = current_caller.count.times.detect do |i|
        next if old_caller.size <= i
        current_caller[i] != old_caller[i]
      end

      if diverge_index
        output << "   Common backtrace:"
        output << "     #{current_caller[0..diverge_index].map { |f| "     #{f}" }.join("\n")}"
        output << "   First call remaining backtrace:"
        output << old_caller[diverge_index..diverge_index + 10].map { |f| "     #{f}" }.join("\n")
        output << "   Current call remaining backtrace:"
        output << current_caller[diverge_index..diverge_index + 10].map { |f| "     #{f}" }.join("\n")
      else
        output << "   Backtraces are identical:"
        output << current_caller.reject { |f| f =~ /gem/ }.first(20).map { |f| "     #{f}" }.join("\n")
      end

      puts output

      notified << sql unless @show_duplicate_notifications
    end

    def strip_backtrace(backtrace)
      backtrace.reject { |frame| frame =~ /active_support|active_record/ }
    end

  end

end