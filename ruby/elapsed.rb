#/usr/bin/env ruby

#
# elapsed.rb
#     Time elapsed + formating seconds
#

dt1 = ARGV[0].to_i + 10800 # 3hrs (gmt-3)
dt2 = ARGV[1].to_i + 10800

diff = dt2 - dt1

print "Date 1 : ", Time.at(dt1).strftime("%Y-%m-%d %H:%M:%S mm:ss"), "\n"
print "Date 2 : ", Time.at(dt2).strftime("%Y-%m-%d %H:%M:%S mm:ss"), "\n"
puts ""

printf "  Diff : %19s secs\n", diff
#rint  "  Diff : ",        Time.at(diff).strftime("              %M:%S mm:ss"), "\n"
#rint  "  Diff : ",(Time.mktime(0)+diff).strftime("           %H:%M:%S elapsed"), "\n"

# Ref: http://stackoverflow.com/questions/1679266/can-ruby-print-out-time-difference-duration-readily
#      http://stufftohelpyouout.blogspot.com/2010/02/seconds-to-days-minutes-hours-seconds.html
#
class Numeric

  def duration
    secs  = self.to_int

    days  =  secs / 86400
    hours = (secs / 3600) - (days  * 24)
    mins  = (secs / 60)   - (hours * 60) - (days * 1440)
    secs  =  secs % 60

    elapsed = sprintf "%3d days %02d:%02d:%02d", days, hours, mins, secs

  end # duration

end   # Numeric

# Using Numeric#duration
print  "  Diff :   ", diff.duration, " elapsed \n"


# post:
#     http://api.rubyonrails.org/classes/ActionView/Helpers/DateHelper.html#method-i-time_ago_in_words
#

