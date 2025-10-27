
/*
administrative_boundaries_level_0
*/
INSERT INTO public.administrative_boundaries_level_0 (
                                                      id,
                                                      country_code,
                                                      country_name, area_type,
                                                      center_point,
                                                      wkb_geometry
) SELECT gen_random_uuid() AS id, 'BD' AS country_code, s.shapeName AS country_name, 'Country' AS area_type, ST_Centroid(s.geom) AS center_point, s.geom AS wkb_geometry FROM public.geoboundaries_bgd_adm0_simplified s

/*
administrative_boundaries_level_2
*/

INSERT INTO public.administrative_boundaries_level_2 (
    division_name,
    country_id,
    country_code,
    country_name,
    state_id,
    state_code,
    state_name,
    area_type,
    center_point,
    wkb_geometry
)
SELECT

    s.shapename AS division_name,
    p.country_id,
    p.country_code,
    p.country_name,
    p.id AS state_id,
    p.state_code,
    p.state_name,
    'Division' AS area_type,
    ST_Centroid(s.geom) AS center_point,
    s.geom AS wkb_geometry
FROM
    public.geoboundaries_bgd_adm1_simplified s
        JOIN
    public.administrative_boundaries_level_1 p
    ON
        ST_Contains(p.wkb_geometry, ST_Centroid(s.geom));



-- =====================================================================
-- INSERT DATA INTO administrative_boundaries_level_3 (District Level)
-- =====================================================================

INSERT INTO public.administrative_boundaries_level_3 (
    district_name,
    division_id,
    division_code,
    division_name,
    country_id,
    country_code,
    country_name,
    state_id,
    state_code,
    state_name,
    area_type,
    center_point,
    wkb_geometry
)
SELECT
    s.shapename AS district_name,
    adm.id AS division_id,
    adm.division_code AS division_code,
    adm.division_name AS division_name,
    adm.country_id AS country_id,
    adm.country_code AS country_code,
    adm.country_name AS country_name,
    adm.id AS state_id,
    adm.state_code AS state_code,
    adm.state_name AS state_name,
    'District' AS area_type,
    ST_Centroid(s.geom) AS center_point,
    s.geom AS wkb_geometry
FROM
    public.geoboundaries_bgd_adm2_simplified s,
    public.administrative_boundaries_level_2 adm
WHERE
    ST_Contains(adm.wkb_geometry, s.center_point)
   or(shapename = 'Noakhali' and adm.division_name= 'Chittagong');


-- =====================================================================
-- INSERT DATA INTO administrative_boundaries_level_4 (SUB-DISTRICT Level)
-- =====================================================================

INSERT INTO public.administrative_boundaries_level_4 (
    sub_district_name,
    district_id,
    district_code,
    district_name,
    division_id,
    division_code,
    division_name,
    country_id,
    country_code,
    country_name,
    state_id,
    state_code,
    state_name,
    area_type,
    center_point,
    wkb_geometry
)
SELECT
    s.shapename AS sub_district_name,
    adm.id AS district_id,
    adm.district_code AS district_code,
    adm.district_name AS district_name,
    adm.division_id AS division_id,
    adm.division_code AS division_code,
    adm.division_name AS division_name,
    adm.country_id AS country_id,
    adm.country_code AS country_code,
    adm.country_name AS country_name,
    adm.id AS state_id,
    adm.state_code AS state_code,
    adm.state_name AS state_name,
    'Sub District' AS area_type,
    ST_Centroid(s.geom) AS center_point,
    s.geom AS wkb_geometry
FROM
    public.geoboundaries_bgd_adm3_simplified s,
    public.administrative_boundaries_level_3 adm
WHERE
    ST_Contains(adm.wkb_geometry, s.center_point);



-- =====================================================================
-- INSERT DATA INTO administrative_boundaries_level_5 (SUB-DISTRICT Level)
-- =====================================================================

INSERT INTO public.administrative_boundaries_level_5 (
    union_name,
    sub_district_id,
    sub_district_code,
    sub_district_name,
    district_id,
    district_code,
    district_name,
    division_id,
    division_code,
    division_name,
    country_id,
    country_code,
    country_name,
    state_id,
    state_code,
    state_name,
    area_type,
    center_point,
    wkb_geometry
)
SELECT
    s.shapename AS union_name,
    adm.id AS sub_district_id,
    adm.sub_district_code AS sub_district_code,
    adm.sub_district_name AS sub_district_name,
    adm.id AS district_id,
    adm.district_code AS district_code,
    adm.district_name AS district_name,
    adm.division_id AS division_id,
    adm.division_code AS division_code,
    adm.division_name AS division_name,
    adm.country_id AS country_id,
    adm.country_code AS country_code,
    adm.country_name AS country_name,
    adm.id AS state_id,
    adm.state_code AS state_code,
    adm.state_name AS state_name,
    'Sub District' AS area_type,
    ST_Centroid(s.geom) AS center_point,
    s.geom AS wkb_geometry
FROM
    public.geoboundaries_bgd_adm4_simplified s,
    public.administrative_boundaries_level_4 adm
WHERE
    ST_Contains(adm.wkb_geometry, s.center_point);





