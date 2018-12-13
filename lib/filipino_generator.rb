# frozen_string_literal: true

require 'active_support/all'
require 'ffaker'
require 'psgc'


# Generate a random set of digits not starting with zero
def random_not_starting_with_zero(n)
  max = 10**n
  min = 10**(n - 1)
  Random.rand(min...max).to_s
end

# Typeface name and normalised pt size
FONTS = {
  'Bartdeng Regular' => 20
}.freeze

# PSGC data
PROVINCES = PSGC::Region.all.map(&:provinces).flatten

# Monkey patch PSGC::ProvinceOrDistrict to add a random city or municipality picker
module PSGC
  # PSGC::ProvinceOrDistrict
  class ProvinceOrDistrict
    def cities_or_municipalities
      @cities_or_municipalities ||= (cities + municipalities)
    end

    def random_city_or_municipality
      cities_or_municipalities.sample
    end
  end
end

# Used for place of birth, and as a superclass for Address
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

# An address
class Address < CountryProvinceMunicipality
  attr_accessor :line_1, :line_2, :zip_code

  def self.random_zip_code
    Random.rand(1000..9999).to_s
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

# A struct to hold PH government ID data
class GovernmentId
  attr_accessor :type, :number
  # Date
  attr_accessor :valid_until
  attr_accessor :image_file

  # Also allows
  TYPES = ['TIN', 'GSIS', 'SSS', 'CRN', 'PASSPORT', 'STUDENT ID']

  # Generates a random government TIN, GSIS, SSS or CRN
  def self.random_tin_gsis_sss_or_crn
    GovernmentId.new.tap do |id|
      id.type = TYPES.take(4).sample
      id.number = case id.type
                  when 'TIN'
                    random_not_starting_with_zero(12)
                  when 'GSIS'
                    random_not_starting_with_zero(11)
                  when 'SSS'
                    random_not_starting_with_zero(10)
                  when 'CRN'
                    random_not_starting_with_zero(12)
      end
    end
  end
end

# A Filiino
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
  attr_accessor :government_id

  def full_name
    [first_name, middle_name, last_name, suffix].reject(&:blank?).join(' ')
  end

  NATURE_OF_WORK = {
    'EMPLOYED' => 30,
    'BUSINESS OWNER/FREELANCER' => 25,
    'UNEMPLOYED' => 5,
    'PENSIONER/RETIRED/HOMEMAKER' => 10,
    'STUDENT' => 10,
    'OFW' => 20
  }.freeze

  SOURCE_OF_FUNDS = {
    'EMPLOYED' => 'SALARY',
    'BUSINESS OWNER' => 'INCOME FROM BUSINESS',
    'FREELANCER' => 'INCOME FROM BUSINESS',
    'UNEMPLOYED' => 'REMITTANCES',
    'PENSIONER' => 'REMITTANCES',
    'RETIRED' => 'REMITTANCES',
    'HOMEMAKER' => 'REMITTANCES',
    'STUDENT' => 'SUPPORT FROM RELATIVES',
    'OFW' => 'SALARY'
  }.freeze

  PSIC = <<~PSIC
    Agriculture, forestry and fishing
    Mining and quarrying
    Manufacturing
    Electricity, gas, steam and air-conditioning supply
    Water supply, sewerage, waste management and
    remediation activities
    Construction
    Wholesale and retail trade; repair of motor vehicles and motorcycles
    Transportation and storage
    Accommodation and food service activities
    Information and communication
    Financial and insurance activities
    Real estate activities
    Professional, scientific and technical services
    Administrative and support service activities
    Public administrative and defense; compulsory social security
    Education
    Human health and social work activities
    Arts, entertainment and recreation
    Household and Domestic Services
  PSIC
         .lines.map { |s| s.chomp.upcase }

  class << self
    # Randomized according to
    # 30% Employed
    # 25% Business Owner/Freelancer
    # 5% Unemployed
    # 10% Pensioner/Retired/Homemaker
    # 10% Student
    # 20% OFW
    def random_nature_of_work
      raw_nature_of_work.split('/').sample
    end

    private

    def raw_nature_of_work
      i = Random.rand(100)
      NATURE_OF_WORK.each do |k, w|
        return k if i < w

        i -= w
      end
    end

    def random_passport_number
      (Array.new(2).map { ('A'..'Z').to_a.sample } + Array.new(7).map { Random.rand(10) }).join
    end

    public

    def random_digits(n, prefix = nil)
      ([prefix] + Array.new(n).map { Random.rand(10) }).join
    end

    # Generate a Person record using FFaker
    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
    def generate
      # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
      Person.new.tap do |p|
        male = Random.rand(2) == 1
        p.sex = male ? 'MALE' : 'FEMALE'
        # 20% of the population will have a second name
        n_names = Random.rand(5).zero? ? 2 : 1
        p.first_name = Array.new(n_names).map do
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

        # (+63) + "9" + randomize 9 random numbers
        p.mobile_number = '+639' + Array.new(9) { Random.rand(10) }.join

        p.nationality = 'PHILIPPINES'

        p.nature_of_work = random_nature_of_work
        p.source_of_funds = SOURCE_OF_FUNDS[p.nature_of_work]
        if ['EMPLOYED', 'BUSINESS OWNER/FREELANCER', 'OFW'].include?(p.nature_of_work)
          p.industry = PSIC.sample
          p.name_of_employer = FFaker::Company.name.upcase
        end

        # ONLY IF Nature of Work is NOT Unemployed, Student or Homemaker
        # then choose randomly between generating a TIN, GSIS, SSS, CRN
        unless %w[UNEMPLOYED STUDENT HOMEMAKER].include?(p.nature_of_work)
          id = GovernmentId.random_tin_gsis_sss_or_crn
          case id.type
          when 'TIN'
            p.tin = id.number
          when 'GSIS'
            p.gsis = id.number
          when 'SSS'
            p.sss = id.number
          when 'CRN'
            p.crn = id.number
          end
        end

        id = GovernmentId.random_tin_gsis_sss_or_crn
        case p.nature_of_work
        when 'HOMEMAKER'
          id.type = 'PASSPORT'
          id.number = random_passport_number
        when 'STUDENT'
          id.type = 'STUDENT ID'
          id.number = random_not_starting_with_zero(10)
        end
        p.government_id = id
      end
    end
  end
end
