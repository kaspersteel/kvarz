CONCAT(
adres.subject_name
        , ', '
        , adres.city_name
        , ', '
        , adres.street_name
        , ', '
        , adres.house
)
LEFT JOIN fias_address.addresses adres ON o.attr_1076_ = adres.id 

adres.subject_name, adres.city_name, adres.street_name, adres.house