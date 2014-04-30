#
# Reference:
#     http://www.ruby-doc.org/stdlib-2.1.1/libdoc/net/http/rdoc/Net/HTTP.html
#     http://apidock.com/ruby/Net/HTTP
#     http://www.ruby-doc.org/stdlib-2.1.1/libdoc/uri/rdoc/URI.html
#     http://apidock.com/ruby/URI
#     http://www.ruby-doc.org/stdlib-2.1.1/libdoc/open-uri/rdoc/OpenURI.html
#

# GET
mv      = JSON.parse( Net::HTTP::get( URI.parse('https://api.github.com/users/mv'           ) ) )
mv_keys = JSON.parse( Net::HTTP::get( URI.parse('https://api.github.com/users/mv/keys'      ) ) )

nu      = JSON.parse( Net::HTTP::get( URI.parse('https://api.github.com/users/nubank'       ) ) )
nu_team = JSON.parse( Net::HTTP::get( URI.parse('https://api.github.com/orgs/nubank/members') ) )

# POST

## 1
payload={'test' => 'This is a test', 'id' => 101}
uri = URI('http://192.168.10.41/cgi-bin/cgi.sh')

res = Net::HTTP.post_form(uri, payload)
puts res.body


## 2
payload={'test' => 'This is a test', 'id' => 102}
req = Net::HTTP.post_form( URI('http://192.168.10.41/cgi-bin/cgi.sh'), payload )
puts res.body


## 3
uri = URI('http://192.168.10.41/cgi-bin/cgi.sh')
payload={'test' => 'This is a test', 'id' => 103}

### build request
req = Net::HTTP::Post.new(uri)
req.set_form_data( payload )

### build response
http = Net::HTTP.new( uri.host, uri.port )
res = http.request( req )
puts res.body


## 4
uri = URI('http://192.168.10.41/cgi-bin/cgi.sh')
payload={'test' => 'This is a test', 'id' => 104}

### build request
req = Net::HTTP::Post.new(uri, payload)

### build response
res = Net::HTTP.new( uri.host, uri.port ).request( req )
puts res.body


# vim:ft=ruby:

