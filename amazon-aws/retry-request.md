

currentRetry = 0
do

  status = execute( AmazonSimpleDB.request )

  if status == success
  then

    retry = false   ; # success: DO NOT RETRY
    process( response );

  elsif status == client.error(4xx)

    retry = false   ; # error 4xx: DO NOT RETRY
    process( client.error )

  else

    retry = true ;
    currentRetry = currentRetry + 1;
    random_delay = ( 0 .. 4^currentRetry * 100 ) # between 0 and 400 milliseconds
    wait_for random_delay ;

  end


while( retry = true AND currentRetry < MaxNumberOfRetries )


