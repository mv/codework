#!/usr/bin/env ruby
#
# get xml repos
#
# Marcus Vinicius Ferreira      ferreira.mv@gmail.com
# 2010/10
#

require "rubygems"
require "net/http"
require "uri"

# ============ Obs!!!!!!!
# Mudar a senha de USERNAME invalida a chave abaixo
# Se mudar a senha, a chave deve ser atualizada
BASE_URL         = "http://abril.codebasehq.com/"
USERNAME         = "lfcipriani"
CODEBASE_API_KEY = "4swb3za36ez2ufsk1wm32vw45f8qcvsfd29i43jp"

def http_request(method, path)
  url = URI.parse(BASE_URL + path)
  req = Net::HTTP::Get.new(url.path)
  req.basic_auth(USERNAME, CODEBASE_API_KEY)
  req.add_field('Accept', 'application/xml')

  res = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
  return res
end

# ============ Retrieving projects
# puts "Projetos...."
projects_xml = http_request(:get, "projects").body
puts projects_xml

# vim:ft=ruby


