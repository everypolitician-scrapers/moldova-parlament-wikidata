#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

sparq = <<EOS
  SELECT ?item
  WHERE {
    ?item p:P39 ?position_statement .
    ?position_statement ps:P39 wd:Q18390049 ;    # Member of the parliament of Moldova
                        pq:P2937 wd:Q20431862 .  #   parliamentary term: XX
  }
EOS
ids = EveryPolitician::Wikidata.sparql(sparq)

names = EveryPolitician::Wikidata.wikipedia_xpath( 
  url: 'https://ro.wikipedia.org/wiki/Legislatura_2014-2018_(Republica_Moldova)',
  xpath: '//table[.//th[contains(.,"Nume")]]//tr[td]/td[2]//a[not(@class="new")]/@title',
) 
EveryPolitician::Wikidata.scrape_wikidata(ids: ids, names: { ro: names })
