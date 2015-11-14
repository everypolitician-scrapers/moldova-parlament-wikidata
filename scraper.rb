#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'wikidata/fetcher'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'rest-client'

def noko_for(url)
  Nokogiri::HTML(open(url).read) 
end

def wikinames(url)
  noko = noko_for(url)
  noko.xpath('//table[.//th[contains(.,"Nume")]]//tr[td]/td[2]//a[not(@class="new")]/@title').map(&:text)
end

names = wikinames('https://ro.wikipedia.org/wiki/Legislatura_2014-2018_(Republica_Moldova)')
abort "No names" if names.count.zero?

WikiData.ids_from_pages('ro', names).each_with_index do |p, i|
  data = WikiData::Fetcher.new(id: p.last).data('ro') rescue nil
  unless data
    warn "No data for #{p}"
    next
  end
  ScraperWiki.save_sqlite([:id], data)
end
warn RestClient.post ENV['MORPH_REBUILDER_URL'], {} if ENV['MORPH_REBUILDER_URL']

