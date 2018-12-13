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
    "sex": "FEMALE",
    "first_name": "LIDA",
    "middle_name": "DACUDAG",
    "last_name": "FAJARDO",
    "birth_date": "1998-07-12",
    "place_of_birth": {
      "country": "PHILIPPINES",
      "province_or_state": "NUEVA ECIJA",
      "city_or_municipality": "QUEZON"
    },
    "permanent_address": {
      "country": "PHILIPPINES",
      "province_or_state": "NEGROS OCCIDENTAL",
      "city_or_municipality": "MOISES PADILLA (MAGALLON)",
      "line_1": "43736 CRIST DAM",
      "line_2": "SAGAPONACK SEASIDE",
      "zip_code": "3826"
    }
  }
]
```

To generate more records, just supply the number of records desired as the parameter to `generate.rb` (defaults to 1 if not given)
