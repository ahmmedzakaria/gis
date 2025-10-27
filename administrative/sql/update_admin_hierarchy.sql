ALTER TABLE public.geoboundaries_bgd_adm0_simplified
ADD COLUMN IF NOT EXISTS center_point geometry(Point, 4326);

UPDATE public.geoboundaries_bgd_adm0_simplified
SET center_point = ST_Centroid(geom);


ALTER TABLE public.geoboundaries_bgd_adm1_simplified
ADD COLUMN IF NOT EXISTS center_point geometry(Point, 4326);

UPDATE public.geoboundaries_bgd_adm1_simplified
SET center_point = ST_Centroid(geom);

ALTER TABLE public.geoboundaries_bgd_adm2_simplified
ADD COLUMN IF NOT EXISTS center_point geometry(Point, 4326);

UPDATE public.geoboundaries_bgd_adm2_simplified
SET center_point = ST_PointOnSurface(geom);

ALTER TABLE public.geoboundaries_bgd_adm3_simplified
ADD COLUMN IF NOT EXISTS center_point geometry(Point, 4326);

/*
computing a point guaranteed to lie inside the polygon,
using ST_PointOnSurface() instead of ST_Centroid().
*/
UPDATE public.geoboundaries_bgd_adm3_simplified
SET center_point = ST_PointOnSurface(geom);

ALTER TABLE public.geoboundaries_bgd_adm4_simplified
ADD COLUMN IF NOT EXISTS center_point geometry(Point, 4326);

UPDATE public.geoboundaries_bgd_adm4_simplified
SET center_point = ST_PointOnSurface(geom);




-- =====================================================
-- 🗺️ Update Administrative Hierarchy (ADM0 → ADM4)
-- Compatible with PostgreSQL 16+
-- =====================================================

-- 1️⃣ ADM1 → ADM0
ALTER TABLE public.geoboundaries_bgd_adm1_simplified
ADD COLUMN IF NOT EXISTS parent_name VARCHAR;

UPDATE public.geoboundaries_bgd_adm1_simplified AS adm1
SET parent_name = adm0.shapename
FROM public.geoboundaries_bgd_adm0_simplified AS adm0
WHERE ST_Contains(adm0.geom, ST_Centroid(adm1.geom));

-- =====================================================

-- 2️⃣ ADM2 → ADM1
ALTER TABLE public.geoboundaries_bgd_adm2_simplified
ADD COLUMN IF NOT EXISTS parent_name VARCHAR;

UPDATE public.geoboundaries_bgd_adm2_simplified AS adm2
SET parent_name = adm1.shapename
FROM public.geoboundaries_bgd_adm1_simplified AS adm1
WHERE ST_Contains(adm1.geom, ST_Centroid(adm2.geom));

-- =====================================================

-- 3️⃣ ADM3 → ADM2
ALTER TABLE public.geoboundaries_bgd_adm3_simplified
ADD COLUMN IF NOT EXISTS parent_name VARCHAR;

UPDATE public.geoboundaries_bgd_adm3_simplified AS adm3
SET parent_name = adm2.shapename
FROM public.geoboundaries_bgd_adm2_simplified AS adm2
WHERE ST_Contains(adm2.geom, ST_Centroid(adm3.geom));

-- =====================================================

-- 4️⃣ ADM4 → ADM3
ALTER TABLE public.geoboundaries_bgd_adm4_simplified
ADD COLUMN IF NOT EXISTS parent_name VARCHAR;

UPDATE public.geoboundaries_bgd_adm4_simplified AS adm4
SET parent_name = adm3.shapename
FROM public.geoboundaries_bgd_adm3_simplified AS adm3
WHERE ST_Contains(adm3.geom, ST_Centroid(adm4.geom));

-- =====================================================

-- ✅ Optional: Verify updates
SELECT 'ADM1 → ADM0' AS level, COUNT(*) AS updated
FROM public.geoboundaries_bgd_adm1_simplified WHERE parent_name IS NOT NULL
UNION ALL
SELECT 'ADM2 → ADM1', COUNT(*) FROM public.geoboundaries_bgd_adm2_simplified WHERE parent_name IS NOT NULL
UNION ALL
SELECT 'ADM3 → ADM2', COUNT(*) FROM public.geoboundaries_bgd_adm3_simplified WHERE parent_name IS NOT NULL
UNION ALL
SELECT 'ADM4 → ADM3', COUNT(*) FROM public.geoboundaries_bgd_adm4_simplified WHERE parent_name IS NOT NULL;
