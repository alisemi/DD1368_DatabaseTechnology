(:  SELECT name FROM Country EXCEPT SELECT name FROM Country WHERE EXISTS (SELECT country FROM geo_Island WHERE country = Country.code) ORDER BY name; :)

(:
for $country in doc(" /Users/Doren Calliku/Desktop/mondial.xml")/mondial/country
let $unlucky := distinct-values( doc("/Users/Doren Calliku/Desktop/mondial.xml")/mondial/island/@country)
order by $country/name
where( not( $unlucky = $country/@car_code))
return  $country/name
:)
 
 
 
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
(:
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

:)


(:3. :)
(:
let $areas :=
  for $lake in doc("mondial.xml")//lake[@island]
    let $country := data($lake/@country)
    for $encompassed in doc("mondial.xml")//country[@car_code= $country]/encompassed
      return <lake_area continent="{data($encompassed/@continent)}">{(data($lake/area)*data($encompassed/@percentage)) div 100} </lake_area>
let $continents := data($areas/@continent)
let $distinct-continents := distinct-values($continents)
for $continent in $distinct-continents
  return <area_sum continent="{$continent}">{sum($areas[@continent = $continent])}</area_sum>
:)

(:4. :)
  

let $country_future_pop :=
for $country in doc("mondial.xml")//country
  return <country>
  <future_population continent="{$country/encompassed/@continent}">
   {data($country/population[@year =  max($country/population/@year)])
  * math:pow((1+0.01*data($country/population_growth)),50)} 
  </future_population>
  </country>
  
let $country_current_pop :=
for $country in doc("mondial.xml")//country
  return <country>
  <current_population continent="{$country/encompassed/@continent}">
   {data($country/population[@year =  max($country/population/@year)])} 
  </current_population>
  </country>
  
let $country_future_pop_N := $country_future_pop/*[normalize-space()]
let $country_current_pop_N := $country_current_pop/*[normalize-space()]
let $continents := distinct-values(data(doc("mondial.xml")//country/encompassed/@continent))

let $continent_pop := 
for $continent in $continents
  return <continent_pop continent="{$continent}">
  <current>{sum($country_current_pop_N[@continent = $continent])}
  </current>
  <future>{sum($country_future_pop_N[@continent = $continent])}
  </future>
  <difference>
  {sum($country_future_pop_N[@continent = $continent]) - sum($country_current_pop_N[@continent = $continent])}
   </difference>
   <ratio>
   {sum($country_future_pop_N[@continent = $continent]) div sum($country_current_pop_N[@continent = $continent])}
   </ratio>
   </continent_pop>

for $continent in $continent_pop
  where $continent/difference = min($continent_pop/difference) or $continent/difference = max($continent_pop/difference)
  return $continent


