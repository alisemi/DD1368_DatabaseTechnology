(: 
1
 SELECT name FROM Country EXCEPT SELECT name FROM Country WHERE EXISTS (SELECT country FROM geo_Island WHERE country = Country.code) ORDER BY name; :)

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
  
(:
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
:)

(: 5th 
let $eu_organizations :=
for $organization in doc("mondial.xml")//organization
  let $headq := $organization/@headq
  let $country_code := doc("mondial.xml")//city[@id = $headq]/@country
  where doc("mondial.xml")//country[@car_code = $country_code]/encompassed[@continent = "europe"]
  and contains(data($organization/name), "International")
  return $organization
let $eu_countries_organization :=
for $organization in $eu_organizations
  let $countries := tokenize( data($organization/members/@country)[1], '\s')
  for $country in $countries
  where doc("mondial.xml")//country[@car_code = $country]/encompassed[@continent = "europe"]
  return <organization country="{$country}" id="{$organization/@id}">{$organization}</organization>
let $ids := distinct-values($eu_countries_organization/@id)
let $counts :=
for $id in $ids
  return <org id="{$id}">{count($eu_countries_organization[@id = $id])}</org>
let $org_id :=
for $count in $counts
where $count = max($counts)
return $count
for $org in $eu_organizations
  return $org[@id = $org_id/@id]
 :)
 
 
 (: 6
let $american := (
for $country in doc("mondial.xml")/mondial/country
where $country/encompassed/@continent="america"
return $country/@car_code
)

let $cities := (
  for $city in doc("mondial.xml")/mondial/country/city
  where $city/population[@year = max($city/population/@year)] > 100000
  return $city/@id
)

for $airport in doc("mondial.xml")/mondial/airport
where $airport/@city = $cities
return <airport city="{$airport/@city}">{data($airport/name)}</airport>

:)


(: 7

for $country in doc("mondial.xml")//country
let $earliest := round-half-to-even($country/population[@year =  min($country/population/@year)], 1)
let $latest   := round-half-to-even( $country/population[@year =  max($country/population/@year)], 1)
let $ratio    :=round-half-to-even(  data($latest) div data($earliest),1)
where  $ratio > 10
return <country earliest="{$earliest}" latest= "{$latest}" ratio ="{$ratio}"> {data($country/name)}</country>

:)

(:8 too slow but works:)
(:
let $cities := 
for $city in doc("mondial.xml")//city
where $city/population > 5000000
return $city

let $distances := 
for $city in $cities
for $other in $cities
return <distance from="{$city/@id}" to="{$other/@id}">
{math:sqrt( math:pow( (abs(data($city/latitude)-data($other/latitude) ) * 111),2 ) +
math:pow( (abs(data($city/longitude)-data($other/longitude) ) * 111),2 ) )}</distance>


let $two :=
for $distance1 in $distances
for $distance2 in $distances
where $distance1/@to = $distance2/@from
and ($distance1/@to != $distance1/@from and $distance2/@to != $distance2/@from)
and $distance2/@to != $distance1/@from

let $third := $distances[@from = $distance2/@to and @to = $distance1/@from]
return <two first="{$distance1/@from}" second="{$distance2/@from}"
 third="{$third/@from}">{sum($distance1 + $distance2 + $third ) }</two>

for $foo in $two
where $foo = max($two)
return $foo
:)

(: 9 :)

(: This function just shows the rivers in the river system, kept for demonstration 
and study:)
declare function local:river_feed(
   $queue  as element(river)*  
) as element(river)*
{
   if ( empty($queue) ) then (
      ()
   )
   else (
      let $more_id := doc("mondial.xml")//river/to[@water = $queue/@id]/../@id
      for $id in $more_id
      return
         ( 
           doc("mondial.xml")//river[@id = $id],
           local:river_feed( doc("mondial.xml")//river[@id = $id] )
         )
   )
};

(: This function calculates longest river system for given river, given river length
is not included:)
declare function local:river_feed2(
   $queue  as element(river)*  
) as xs:double*
{
    
   let $more_id := doc("mondial.xml")//river/to[@water = $queue/@id]/../@id
   return 
   if ( empty($more_id) ) then (
      0
   )
   else (
      for $id in $more_id 
      return
         ( max(
           data(doc("mondial.xml")//river[@id = $id]/length) + 
           local:river_feed2( doc("mondial.xml")//river[@id = $id] )[1]
           )
         )
        
   )
};

(:
let $nile_system := local:river_feed2(doc("mondial.xml")//river[@id = "river-Nil"])
let $rhein_system := local:river_feed2(doc("mondial.xml")//river[@id = "river-Rhein"])
let $amazonas_system := local:river_feed2(doc("mondial.xml")//river[@id = "river-Amazonas"])

return 'Nile' || ': ' || doc("mondial.xml")//river[@id = "river-Nil"]/length + max($nile_system)  || '&#xa;' || 
'Rhein' || ': ' || doc("mondial.xml")//river[@id = "river-Rhein"]/length + max($rhein_system) || '&#xa;' || 
'Amazonas' || ': ' || doc("mondial.xml")//river[@id = "river-Amazonas"]/length + max($amazonas_system)
:)

(: C :)

(: C-1 :)
(: the solution below is not working
declare function local:cross_border(
   $cross_number as xs:integer,
   $current  as element(country)*,
   $visited as element(country)*  
)
{
  let $borders := 
  for $border in $current/border
  where not (exists(doc("mondial.xml")//country[@car_code = data($border/@country)] intersect $visited))
  return doc("mondial.xml")//country[@car_code = data($border/@country)]
  return
   if ( empty($borders)) then (
      ()
   )
   else (
      for $border in $borders
      return
         ( 
           $border/name  || '-' || $cross_number, 
           local:cross_border( $cross_number + 1, $border, ($visited, $borders)  )
         )
   )
};

declare function local:cross_border2(
   $cross_number as xs:integer,
   $current  as element(country)*,
   $visited  as element(country)*  
)
{
  let $borders := 
  for $border in $current/border
  where  not (exists(doc("mondial.xml")//country[@car_code = data($border/@country)] intersect $visited))
  return doc("mondial.xml")//country[@car_code = data($border/@country)]
  return
   if ( empty($borders)) then (
      ()
   )
   else (
      for $border in $borders
      return
         ( 
           $border/name  || '-' || $cross_number, 
           local:cross_border( $cross_number + 1, $border, ($visited, $borders)  )
         )
   )
};


let $foo := distinct-values(local:cross_border2(1,doc("mondial.xml")//country[@car_code = 'S'], (doc("mondial.xml")//country[@car_code = 'S']) ) )
for $bar in $foo
return $bar
:)

(: C - 1 - second approach ( this one is working):)
declare function local:reachable(
   $queue  as element(country)*,
   $result as element(country)*,
   $cross_number_queue as xs:integer*,
   $cross_number_result as xs:integer*   
)
{
   if ( empty($queue) ) then (
      (:<country crossNo="tail($cross_number_result)">{data(tail($result/[@car_code]))}</country>:)
      let $a := tail($cross_number_result)
      let $b := data(tail($result)/[@car_code])
      for $x at $pos in $a return
      <item cross_border="{$x}" country_code="{$b[$pos]}"/>
   )
   else (
      let $this := head($queue)
      let $this_cross_number := head($cross_number_queue)
      
      let $rest := tail($queue)
      let $rest_cross_number := tail($cross_number_queue)
      
      let $more := $this/border/@country[not(. = ($queue, $result)/@car_code)]
      let $more_cross_number := ()
      let $more_cross_number := for $more_country in $more
          let $more_cross_number := fn:insert-before($more_cross_number, last(), $this_cross_number+1)
          return $more_cross_number
      (: more_cross_number is generated a number for each element in the queue :)
      
     
      return
         local:reachable(
            ( $rest, doc("mondial.xml")//country[@car_code= $more] ),
            ( $result, $this ), ($rest_cross_number, $more_cross_number) , ($cross_number_result, $this_cross_number) ) 
   )
};

(:
let $r := local:reachable(doc("mondial.xml")//country[@car_code= 'S'], (), (0), () )
return $r
:)

(: C - 2 :)

for $country in doc("mondial.xml")//country
let $r := local:reachable($country, (), (0), () )
let $highest_cross := max($r/@cross_border)
let $high_country := $r[@cross_border = $highest_cross]
return <country name="{$country/name}" highest_border="{$highest_cross}">{$high_country}</country>


(: D :)
(: ADD ATTRIBUTES :)
declare function local:add-attributes
  ( $elements as element()* ,
    $attrNames as xs:QName* ,
    $attrValues as xs:anyAtomicType* ) {

   for $element in $elements
   return element { node-name($element)}
                  { for $attrName at $seq in $attrNames
                    return if ($element/@*[node-name(.) = $attrName])
                           then ()
                           else attribute {$attrName}
                                          {$attrValues[$seq]},
                    $element/@*,
                    $element/node() }
 } ;

 
declare function local:add-attribute
  ( $element as element(), $mid_elem as element() )  as element()* {
    let $sub_elements := $element/* 
    return if( empty($sub_elements))
    then (
        local:add-attributes($mid_elem, QName('', 'value'),  data($element) )
    )
    else
      let $qnames := for $sub in $sub_elements
      return QName('', name($sub))
      let $datas := for $sub in $sub_elements
      return data($sub)
      return local:add-attributes($mid_elem,$qnames,  $datas )
    } ;
 
 
for $elem in doc("songs.xml")/music/*
let $mid_elem := element {name($elem)} {
          for $child in $elem/(@*|text())
          
          return if ($child instance of attribute())
          then( element 
            { name($child)
            }
            { string($child)
            })
          else
            ''
            
       }
let $mid_elem_att := local:add-attribute($elem, $mid_elem)
return $mid_elem_att 
