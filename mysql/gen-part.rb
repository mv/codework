require 'date'

###
### por ano
###
year = 2009
dt_init = Time.utc( year, 01, 01, 00, 00, 00)  # , 00, 00, 00, "+00:00")
for i in 1..2

  dt_limit = Time.utc( year + 1, 01, 01, 00, 00, 00, "00:00" )

  #  , PARTITION p2012_w01 VALUES LESS THAN ( 20120101 ) -- 2012-01-01
	puts "    , PARTITION p#{year}       VALUES LESS THAN ( #{dt_limit.strftime('%s')} ) -- #{dt_limit.strftime('%Y-%m-%d %H:%M:%S')}"
	year += 1

end
puts "    --"

###
### por mes
###
year = 2011
dt_init = Time.utc( year, 01, 01)
for i in 1..12

  mm = sprintf( "%02d", i )
  begin
    dt_limit = Time.utc( year, i+1, 01)
  rescue
    dt_limit = Time.utc( year+1, 01, 01)
  end

  #  , PARTITION p2012_w01 VALUES LESS THAN ( 20120101 ) -- 2012-01-01
	puts "    , PARTITION p#{year}_m#{mm}   VALUES LESS THAN ( #{dt_limit.strftime('%s')} ) -- #{dt_limit.strftime('%Y-%m-%d')}"

end
puts "    --"

###
### por dia
###

year = 2012
dt_init = Time.utc( year, 01, 01, 0, 0, 0)
dt_part = Date.new( year, 01, 01 )
for i in 1..366 # bissexto: 366

  dt       = dt_init.strftime('%s').to_i + ( i * 24 * 60 * 60 )
  dt_limit = dt_part + 1

  #  , PARTITION p2012_w01 VALUES LESS THAN ( 20120101 ) -- 2012-01-01
	puts "    , PARTITION p#{dt_part.strftime('%Y_%m_%d')} VALUES LESS THAN ( #{dt} ) -- #{dt_limit.strftime('%Y-%m-%d %H:%M:%S')}"

  dt_part += 1

end

