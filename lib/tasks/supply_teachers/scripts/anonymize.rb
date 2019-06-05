#!/usr/bin/env ruby
require 'bundler/setup'
require 'faker'
require 'json'
require 'jsonpath'
require 'securerandom'

def anonymize
  Faker::Config.locale = 'en-GB'

  json = File.read('./storage/supply_teachers/current_data/output/data.json.tmp')

  hash =
    JsonPath
    .for(json)
    .gsub('..supplier_name') { Faker::Company.name }
    .gsub('..supplier_id') { SecureRandom.uuid }
    .gsub('..telephone') { Faker::PhoneNumber.unique.phone_number }
    .gsub('..contacts.*.name') { Faker::Name.unique.name }
    .gsub('..contacts.*.email') { Faker::Internet.unique.email }
    .gsub('..master_vendor_contact.telephone') { Faker::PhoneNumber.unique.phone_number }
    .gsub('..master_vendor_contact.name') { Faker::Name.unique.name }
    .gsub('..master_vendor_contact.email') { Faker::Internet.unique.email }
    .gsub('..neutral_vendor_contact.telephone') { Faker::PhoneNumber.unique.phone_number }
    .gsub('..neutral_vendor_contact.name') { Faker::Name.unique.name }
    .gsub('..neutral_vendor_contact.email') { Faker::Internet.unique.email }
    .gsub('..branch_name'){ Faker::Company.name }
    .to_hash

  File.open('./storage/supply_teachers/current_data/output/anonymous.json.tmp', 'w') do |f|
    f.puts JSON.pretty_generate(hash)
  end
end
