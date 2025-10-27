/*
merged_geometry point and geom
*/
select ST_Collect(geom, center_point) AS merged_geometry
from geoboundaries_bgd_adm3_simplified where shapename not in(
SELECT
    s.shapename AS union_name
FROM
    public.geoboundaries_bgd_adm3_simplified s,
    public.administrative_boundaries_level_3 adm
WHERE
    ST_Contains(adm.wkb_geometry, s.center_point)
)
/*
computing a point guaranteed to lie inside the polygon,
using ST_PointOnSurface() instead of ST_Centroid().
*/
SELECT
    s.shapename AS union_name
FROM
    public.geoboundaries_bgd_adm3_simplified s,
    public.administrative_boundaries_level_3 adm
WHERE
    ST_Contains(adm.wkb_geometry, ST_PointOnSurface(geom))
