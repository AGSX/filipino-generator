# filipino-generator

Generates 'fake' Filipinos. Uses the [`ffaker`](https://github.com/ffaker/ffaker) and [`psgc`](https://github.com/aisrael/psgc) gems.

### Requires

* Ruby 2.5.3

### Usage

```
$ bundle exec ruby generate.rb 1
```

Will generate something like
```
[
  {
    "sex": "MALE",
    "firstName": "AGUSTIN",
    "middleName": "MAGBANTAYG",
    "lastName": "PAGSISIHANG",
    "birthDate": "1965-01-19",
    "placeOfBirth": {
      "country": "PHILIPPINES",
      "provinceOrState": "NEGROS OCCIDENTAL",
      "cityOrMunicipality": "ISABELA"
    },
    "permanentAddress": {
      "country": "PHILIPPINES",
      "provinceOrState": "NUEVA ECIJA",
      "cityOrMunicipality": "CUYAPO",
      "line1": "24795 CHARLSIE VIEWS",
      "line2": "NORTH EAST IRWINDALE",
      "zipCode": "2947"
    },
    "presentAddress": {
      "country": "PHILIPPINES",
      "provinceOrState": "NUEVA ECIJA",
      "cityOrMunicipality": "CUYAPO",
      "line1": "24795 CHARLSIE VIEWS",
      "line2": "NORTH EAST IRWINDALE",
      "zipCode": "2947"
    },
    "mobileNumber": "+639014172409",
    "nationality": "PHILIPPINES",
    "natureOfWork": "OFW",
    "sourceOfFunds": "SALARY",
    "industry": "REMEDIATION ACTIVITIES",
    "nameOfEmployer": "DUBUQUE LLC",
    "crn": "181458946208",
    "governmentId": {
      "type": "TIN",
      "number": "485541207896"
    }
  }
]
```

To generate more records, just supply the number of records desired as the parameter to `generate.rb` (defaults to 1 if not given)
