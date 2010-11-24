#!/usr/bin/env ruby
#
# codebase_mirror.rb
#     Cria um mirror local dos repositorios Abril do Codebase
#
# Luis Cipriani                 lfcipriani@gmail.com
# Marcus Vinicius Ferreira      ferreira.mv@gmail.com
# 2010/07
#

require "rubygems"
require "uri"
require "net/http"
require "nokogiri"

# ============ Obs!!!!!!!
# Mudar a senha de USERNAME invalida a chave abaixo
# Se mudar a senha, a chave deve ser atualizada
BASE_URL         = "http://abril.codebasehq.com/"
USERNAME         = "lfcipriani"
CODEBASE_API_KEY = "4swb3za36ez2ufsk1wm32vw45f8qcvsfd29i43jp"

MIRROR_PATH = "/abd/git/mirror"

def http_request(method, path)
  url = URI.parse(BASE_URL + path)
  req = Net::HTTP::Get.new(url.path)
  req.basic_auth(USERNAME, CODEBASE_API_KEY)
  req.add_field('Accept', 'application/xml')

  res = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
  return res
end

def git_fetch(path)
  puts "Fetch: #{path}\n"
  system("cd #{path} && git fetch 2>/dev/null")
  puts ""
end

def git_clone(clone,path)
  puts "Clone: #{clone} - #{path}"
  system("mkdir -p #{path}")
  system("cd #{path} && git clone --mirror #{clone} 2>/dev/null")
  puts ""
end

# ============ Retrieving projects
# puts "Projetos...."
projects_xml = http_request(:get, "projects").body
     xml_doc = Nokogiri::XML.parse(projects_xml)
    projects = xml_doc.xpath("projects/project/permalink").map { |permalink| permalink.text }

# ============ Retrieving repositories by project
# puts "Repositorios...."
printf "%-30s %-30s %s\n", "# Projeto","Repositorio","Clone URL"

projects.each do |project|
  repositories_xml = http_request(:get, "#{project}/repositories").body
           xml_doc = Nokogiri::XML.parse(repositories_xml)
      repositories = xml_doc.xpath("repositories/repository/permalink").map { |permalink| permalink.text }

  # ============ Printing
  repositories.each do |repo|

    clone_url = "git@codebasehq.com:abril/#{project}/#{repo}.git"
    clone_dir = "#{MIRROR_PATH}/#{project}"

    # puts "#{project}, #{repo}"
    printf "%-30s %-30s %s\n", project, repo, clone_url

    if File.directory?(clone_dir)
        git_fetch(clone_dir)
    else
        git_clone(clone_url, clone_dir)
    end

  end # |repo|

end # |project| 

# vim:ft=ruby:

