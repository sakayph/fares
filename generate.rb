#!/usr/bin/env ruby

require 'csv'

# current as of February 2017
fare_types = {
  "pub_aircon" => {
    "fare" => 12.00,
    "firstkm" => 5,
    "perkm" => 2.2,
    "limit" => 60
  },
  "pub_ordinary" => {
    "fare" => 10.00,
    "firstkm" => 5,
    "perkm" => 1.85,
    "limit" => 60
  },
  "puj" => {
    "fare" => 8.00,
    "firstkm" => 4,
    "perkm" => 1.5,
    "limit" => 50
  }
}

def round(original)
  "%.2f" % ((original*4).round/4.0)
end

def if_override(original, type, dist, name)
  value = original
  value = type['override'][dist][name] if type['override'] && type['override'][dist] && type['override'][dist][name]
  value
end

fare_types.each do |key, type|
  CSV.open(key+'.csv', 'wb') do |csv|
    csv << ['distance', 'regular', 'discounted']
    type['limit'].times do |x|
      dist = x+1
      fare = type['fare']
      if dist > type['firstkm']
        fare += type['perkm'] * (dist - type['firstkm'])
      end
      discounted = round(fare*0.8)
      fare = round(fare)
      discounted = if_override(discounted, type, dist, 'discounted')
      fare = if_override(fare, type, dist, 'fare')
      csv << [dist, fare, discounted]
    end
  end
end
