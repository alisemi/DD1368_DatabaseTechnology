(:  SELECT name FROM Country EXCEPT SELECT name FROM Country WHERE EXISTS (SELECT country FROM geo_Island WHERE country = Country.code) ORDER BY name; :)

for $country in doc(" /Users/Doren Calliku/Desktop/mondial.xml")/mondial/country
let $unlucky := distinct-values( doc("/Users/Doren Calliku/Desktop/mondial.xml")/mondial/island/@country)
order by $country/name
where( not( $unlucky = $country/@car_code))
return  $country/name
 
 
 