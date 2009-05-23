module Bananajour
  module GravatarHelpers
    def gravatar(email)
      "http://gravatar.com/avatar/#{MD5.md5(email)}.png"
    end
  end
  
  # Lifted from Rails
  module DateHelpers
    # Reports the approximate distance in time between two Time or Date objects or integers as seconds.
    # Set <tt>include_seconds</tt> to true if you want more detailed approximations when distance < 1 min, 29 secs
    # Distances are reported based on the following table:
    #
    #   0 <-> 29 secs                                                             # => less than a minute
    #   30 secs <-> 1 min, 29 secs                                                # => 1 minute
    #   1 min, 30 secs <-> 44 mins, 29 secs                                       # => [2..44] minutes
    #   44 mins, 30 secs <-> 89 mins, 29 secs                                     # => about 1 hour
    #   89 mins, 29 secs <-> 23 hrs, 59 mins, 29 secs                             # => about [2..24] hours
    #   23 hrs, 59 mins, 29 secs <-> 47 hrs, 59 mins, 29 secs                     # => 1 day
    #   47 hrs, 59 mins, 29 secs <-> 29 days, 23 hrs, 59 mins, 29 secs            # => [2..29] days
    #   29 days, 23 hrs, 59 mins, 30 secs <-> 59 days, 23 hrs, 59 mins, 29 secs   # => about 1 month
    #   59 days, 23 hrs, 59 mins, 30 secs <-> 1 yr minus 1 sec                    # => [2..12] months
    #   1 yr <-> 2 yrs minus 1 secs                                               # => about 1 year
    #   2 yrs <-> max time or date                                                # => over [2..X] years
    #
    # With <tt>include_seconds</tt> = true and the difference < 1 minute 29 seconds:
    #   0-4   secs      # => less than 5 seconds
    #   5-9   secs      # => less than 10 seconds
    #   10-19 secs      # => less than 20 seconds
    #   20-39 secs      # => half a minute
    #   40-59 secs      # => less than a minute
    #   60-89 secs      # => 1 minute
    #
    # ==== Examples
    #   from_time = Time.now
    #   distance_of_time_in_words(from_time, from_time + 50.minutes)        # => about 1 hour
    #   distance_of_time_in_words(from_time, 50.minutes.from_now)           # => about 1 hour
    #   distance_of_time_in_words(from_time, from_time + 15.seconds)        # => less than a minute
    #   distance_of_time_in_words(from_time, from_time + 15.seconds, true)  # => less than 20 seconds
    #   distance_of_time_in_words(from_time, 3.years.from_now)              # => over 3 years
    #   distance_of_time_in_words(from_time, from_time + 60.hours)          # => about 3 days
    #   distance_of_time_in_words(from_time, from_time + 45.seconds, true)  # => less than a minute
    #   distance_of_time_in_words(from_time, from_time - 45.seconds, true)  # => less than a minute
    #   distance_of_time_in_words(from_time, 76.seconds.from_now)           # => 1 minute
    #   distance_of_time_in_words(from_time, from_time + 1.year + 3.days)   # => about 1 year
    #   distance_of_time_in_words(from_time, from_time + 4.years + 15.days + 30.minutes + 5.seconds) # => over 4 years
    #
    #   to_time = Time.now + 6.years + 19.days
    #   distance_of_time_in_words(from_time, to_time, true)     # => over 6 years
    #   distance_of_time_in_words(to_time, from_time, true)     # => over 6 years
    #   distance_of_time_in_words(Time.now, Time.now)           # => less than a minute
    #
    def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
      from_time = from_time.to_time if from_time.respond_to?(:to_time)
      to_time = to_time.to_time if to_time.respond_to?(:to_time)
      distance_in_minutes = (((to_time - from_time).abs)/60).round
      distance_in_seconds = ((to_time - from_time).abs).round

      case distance_in_minutes
        when 0..1
          return (distance_in_minutes == 0) ? 'less than a minute' : '1 minute' unless include_seconds
          case distance_in_seconds
            when 0..4   then 'less than 5 seconds'
            when 5..9   then 'less than 10 seconds'
            when 10..19 then 'less than 20 seconds'
            when 20..39 then 'half a minute'
            when 40..59 then 'less than a minute'
            else             '1 minute'
          end

        when 2..44           then "#{distance_in_minutes} minutes"
        when 45..89          then 'about 1 hour'
        when 90..1439        then "about #{(distance_in_minutes.to_f / 60.0).round} hours"
        when 1440..2879      then '1 day'
        when 2880..43199     then "#{(distance_in_minutes / 1440).round} days"
        when 43200..86399    then 'about 1 month'
        when 86400..525599   then "#{(distance_in_minutes / 43200).round} months"
        when 525600..1051199 then 'about 1 year'
        else                      "over #{(distance_in_minutes / 525600).round} years"
      end
    end

    # Like distance_of_time_in_words, but where <tt>to_time</tt> is fixed to <tt>Time.now</tt>.
    #
    # ==== Examples
    #   time_ago_in_words(3.minutes.from_now)       # => 3 minutes
    #   time_ago_in_words(Time.now - 15.hours)      # => 15 hours
    #   time_ago_in_words(Time.now)                 # => less than a minute
    #
    #   from_time = Time.now - 3.days - 14.minutes - 25.seconds     # => 3 days
    def time_ago_in_words(from_time, include_seconds = false)
      distance_of_time_in_words(from_time, Time.now, include_seconds)
    end
  end
end