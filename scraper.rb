#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'
require 'pry'

names = EveryPolitician::Wikidata.wikipedia_xpath( 
  url: 'https://ro.wikipedia.org/wiki/Legislatura_2014-2018_(Republica_Moldova)',
  xpath: '//table[.//th[contains(.,"Nume")]]//tr[td]/td[2]//a[not(@class="new")]/@title',
) 
EveryPolitician::Wikidata.scrape_wikidata(names: { ro: names })
warn EveryPolitician::Wikidata.notify_rebuilder
