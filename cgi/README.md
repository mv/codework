
## CGI bash

### GET
    curl 'http://192.168.10.41/cgi-bin/cgi.sh'
    QUERY_STRING=

    curl 'http://192.168.10.41/cgi-bin/cgi.sh?x=a&y=1'
    QUERY_STRING=x=a&y=1

    curl 'http://192.168.10.41/cgi-bin/cgi.sh?x=a,b,c&y=1,2,3'
    QUERY_STRING=x=a,b,c&y=1,2,3

### POST

    $ cat post-data.hook-id.form-www
    payload=%7B%22zen%22%3A%22Keep+it+logically+awesome.%22%2C%22hook_id%22%3A2061741%7D

    curl -X POST --data "$(cat post-data.hook-id.form-www)" http://192.168.10.41/cgi-bin/cgi.rb
    Standard Input
    --------------
    payload=%7B%22zen%22%3A%22Keep+it+logically+awesome.%22%2C%22hook_id%22%3A2061741%7D


## CGI ruby

### GET
    curl 'http://192.168.10.41/cgi-bin/cgi.rb'
    @params={}

    curl 'http://192.168.10.41/cgi-bin/cgi.rb?x=a&y=1'
    @params={"x"=>["a"], "y"=>["1"]}

    curl 'http://192.168.10.41/cgi-bin/cgi.rb?x=a,b,c&y=1,2,3'
    @params={"x"=>["a,b,c"], "y"=>["1,2,3"]}

### POST

    $ cat post-data.hook-id.form-www
    payload=%7B%22zen%22%3A%22Keep+it+logically+awesome.%22%2C%22hook_id%22%3A2061741%7D

    curl -X POST --data "$(cat post-data.hook-id.form-www)" http://192.168.10.41/cgi-bin/cgi.rb
    @params=
      {"payload"=>
        ["{\"zen\":\"Keep it logically awesome.\",\"hook_id\":2061741}"]
      }

