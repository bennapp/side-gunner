require 'nokogiri'
require 'open-uri'
require 'pry'
require 'json'

def ability_data
  base_ability_url = 'https://abilitydraft.datdota.com/ability-high-skill'
  base_ability_html = URI.open(base_ability_url)
  base_ability_doc = Nokogiri::HTML(base_ability_html)

  table = base_ability_doc.at('tbody')

  cells = table.search('tr').map do |tr|
    tr.search('th, td')
  end

  win_rate_data = cells.map { |cell|
    {
      link: cell[0].children.first.attributes['src'].value,
      name: cell[1].children.first.children.first.text,
      win_rate: cell[3].children.first.text.gsub('%', ''),
      synergies: []
    }
  }

  win_rate_data
    .sort_by { |data| data[:win_rate] }
    .reverse
    .inject({}) { |memo, data|
      memo[data[:name]] = data
      memo
    }
end

def synergy_data
  url = 'https://abilitydraft.datdota.com/ability-pairs'
  html = URI.open(url)
  doc = Nokogiri::HTML(html)

  table = doc.at('tbody')

  cells = table.search('tr').map do |tr|
    tr.search('th, td')
  end

  cells.map { |cell|
    {
      to: cell[1].children.text.strip,
      from: cell[4].children.text.strip,
      win_rate: cell[7].children.first.text.gsub('%', '').strip,
    }
  }
end

abilities = ability_data
synergies = synergy_data

synergies.each do |synergy|

  abilities[synergy[:to]][:synergies].push({
    name: synergy[:from],
    win_rate: synergy[:win_rate],
  })
end

synergies.each do |synergy|
  abilities[synergy[:from]][:synergies].push({
    name: synergy[:to],
    win_rate: synergy[:win_rate],
  })
end

abilities.each do |_key, ability|
  ability[:synergies] = ability[:synergies]
    .sort_by { |synergy| synergy[:win_rate] }
    .reverse
end

File.open("abilityData.js", "w") { |f| f.write('export default ' + JSON.dump(abilities))}
