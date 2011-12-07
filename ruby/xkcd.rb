#
# http://xkcd.com/903/
# Wikipedia trivia: if you take any article, click on the first link in the article text not in parentheses or italics, and then repeat, you will eventually end up at "Philosophy"
#
# Usage: ruby xkcd.rb [keyword]
#
require "rubygems"
require "mechanize"

@agent  = Mechanize.new
@agent.user_agent = "Mozilla/5.0 (X11; Linux x86_64; rv:2.0.1) Gecko/20110506 Firefox/4.0.1"
@agent.redirect_ok = true

def get_wiki_page(word)
  google = @agent.get("http://google.com")
  google_form = google.form('f')
  google_form.q = "site:en.wikipedia.org #{word}"
  page = @agent.submit(google_form)
  page.search('//h3/a[@class="l"]').first['href']

end

def get_link(page)
  #puts page.title
  p = page.search('//div[@id="bodyContent"]/p').each do |p|
     p.children.each do |node|
      #puts node.text
      if newlink = node['href']
        #puts newlink
        unless p.text =~ /\(.*#{node.text}.*\)/
          return "http://en.wikipedia.org#{newlink}"
        end
      end
    end
  end

end

def _next(link)
  if link != "http://en.wikipedia.org/wiki/Philosophy"
    puts "next #{link}"
    _next(get_link(@agent.get(link)))
  else
    puts "Philosophy, AAWWWWWWWW YEAAAAAAHHHHHHHH!"
  end
end

puts "http://xkcd.com/903/"
puts "Wikipedia trivia: if you take any article, click on the first link in the article text not in parentheses or italics, and then repeat, you will eventually end up at \"Philosophy\".\n\n"

_next get_wiki_page(ARGV.first)

