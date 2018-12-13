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
    "firstName": "EARLE EZRA",
    "middleName": "GUTIERREZ",
    "lastName": "CAYETANO",
    "suffix": "JR.",
    "sex": "MALE",
    "birthDate": "1992-04-07",
    "placeOfBirth": {
      "country": "PHILIPPINES",
      "provinceOrState": "BILIRAN",
      "cityOrMunicipality": "BILIRAN"
    },
    "permanentAddress": {
      "country": "PHILIPPINES",
      "provinceOrState": "PANGASINAN",
      "cityOrMunicipality": "BAYAMBANG",
      "line1": "0052 YVONNE RUN",
      "line2": "CIPRIANI",
      "zipCode": "8694"
    },
    "presentAddress": {
      "country": "PHILIPPINES",
      "provinceOrState": "NUEVA ECIJA",
      "cityOrMunicipality": "CUYAPO",
      "line1": "24795 CHARLSIE VIEWS",
      "line2": "NORTH EAST IRWINDALE",
      "zipCode": "2947"
    },
    "mobileNumber": "+639915899666",
    "nationality": "PHILIPPINES",
    "natureOfWork": "BUSINESS OWNER",
    "sourceOfFunds": "INCOME FROM BUSINESS",
    "crn": "130639003313",
    "governmentId": {
      "type": "GSIS",
      "number": "69195090563"
    }
  }
]
```

To generate more records, just supply the number of records desired as the parameter to `generate.rb` (defaults to 1 if not given)
