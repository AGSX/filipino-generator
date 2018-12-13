# frozen_string_literal: true
require 'active_support/all'
require 'ffaker'
require 'psgc'

# Typeface name and normalised pt size
FONTS = {
  'Bartdeng Regular' => 20
}

# PSGC data
PROVINCES = PSGC::Region.all.map(&:provinces).flatten

# Monkey patch PSGC::ProvinceOrDistrict to add a random city or municipality picker
class PSGC::ProvinceOrDistrict
  def cities_or_municipalities
    @cities_or_municipalities ||= (self.cities + self.municipalities)
  end

  def random_city_or_municipality
    cities_or_municipalities.sample
  end
end

class CountryProvinceMunicipality
  attr_accessor :country, :province_or_state, :city_or_municipality

  def self.random
    CountryProvinceMunicipality.new.tap do |cpm|
      cpm.country = 'PHILIPPINES'
      province = PROVINCES.sample
      cpm.province_or_state = province.name.upcase
      cpm.city_or_municipality = province.random_city_or_municipality.name.upcase
    end
  end
end

class Address < CountryProvinceMunicipality
  attr_accessor :line_1, :line_2, :zip_code

  def self.random_zip_code
    (Random.rand(9000) + 1000).to_s
  end

  def self.random
    Address.new.tap do |address|
      address.country = 'PHILIPPINES'
      province = PROVINCES.sample
      address.province_or_state = province.name.upcase
      address.city_or_municipality = province.random_city_or_municipality.name.upcase
      address.line_1 = FFaker::Address.street_address.upcase
      address.line_2 = FFaker::Address.neighborhood.upcase
      address.zip_code = random_zip_code
    end
  end
end

class GovernmentId
  attr_accessor :type, :number
  # Date
  attr_accessor :valid_until
  attr_accessor :image_file
end

class Person
  attr_accessor :first_name, :middle_name, :last_name, :suffix
  attr_accessor :nationality

  # Date
  attr_accessor :birth_date

  # 'male' | 'female'
  attr_accessor :sex

  # CountryProvinceMunicipality
  attr_accessor :place_of_birth

  # Address
  attr_accessor :permanent_address, :present_address

  attr_accessor :mobile_number
  attr_accessor :nature_of_work, :source_of_funds, :industry, :name_of_employer
  attr_accessor :tin, :sss, :gsis, :crn
  attr_accessor :photograph, :specimen_signature

  SETTERS = (Person.instance_methods - Person.superclass.instance_methods).select do |m|
    m.to_s.end_with?('=')
  end.map do |sym|
    sym.to_s[0...-1].to_sym
  end

  def full_name
    [first_name, middle_name, last_name, suffix].reject(&:blank?).join(' ')
  end

  class << self

    # Generate a Person record using FFaker
    def generate
      Person.new.tap do |p|
        male = Random.rand(2) == 1

        p.sex = male ? 'MALE' : 'FEMALE'
        # 20% of the population will have a second name
        n_names = Random.rand(5) == 0 ? 2 : 1
        p.first_name = n_names.times.map do
          male ? FFaker::NamePH.first_name_male : FFaker::NamePH.first_name_female
        end.map(&:upcase).join(' ')
        p.middle_name = FFaker::NamePH.last_name.upcase
        p.last_name = FFaker::NamePH.last_name.upcase
        # 5% of Male to have Sr. 5% of Male to have Jr.
        if male
          case Random.rand(20)
          when 0
            p.suffix = 'SR.'
          when 1
            p.suffix = 'JR.'
          end
        end

        p.birth_date = FFaker::Time.between(70.years.ago, 18.years.ago).to_date.iso8601

        p.place_of_birth = CountryProvinceMunicipality.random

        p.permanent_address = Address.random
      end
    end
  end
end
