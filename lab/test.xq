(:  SELECT name FROM Country EXCEPT SELECT name FROM Country WHERE EXISTS (SELECT country FROM geo_Island WHERE country = Country.code) ORDER BY name; :)

for $country in doc(" /Users/Doren Calliku/Desktop/mondial.xml")/mondial/country
let $unlucky := distinct-values( doc("/Users/Doren Calliku/Desktop/mondial.xml")/mondial/island/@country)
order by $country/name
where( not( $unlucky = $country/@car_code))
return  $country/name
 
 
 
 
(:
 /*
2. 
Generate the ratio between inland provinces (provinces not bordering any sea) to total number of provinces.
*/
SELECT 1.0 * ( 
WITH Province_CTE AS(
	SELECT name FROM Province EXCEPT SELECT name FROM Province WHERE EXISTS ( SELECT province FROM geo_Sea WHERE province = Province.name)) 
SELECT COUNT(name) FROM Province_CTE)/(SELECT COUNT(name) FROM Province) as ratio;
:)
let $count1 := count(for $prov in doc("mondial.xml")/mondial/country/province
  let $unlucky := distinct-values( doc("mondial.xml")/mondial/sea/located/@province)
  where(not( $unlucky = $prov/@id ))
  return  $prov/name
)

let $count2 := count(for $prov in doc("mondial.xml")/mondial/country/province
  let $unlucky := distinct-values( doc("mondial.xml")/mondial/sea/located/@province)
  where( $unlucky = $prov/@id )
  return  $prov/name
)

return $count1 div ($count2 + $count1)