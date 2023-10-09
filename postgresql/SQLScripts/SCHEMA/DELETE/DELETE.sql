/*****************************************************************
* CONTENT
*
* FUNCTIONS:
* citydb.cleanup_schema() RETURNS SETOF void
* citydb.delete_feature(bigint[]) RETURNS SETOF BIGINT
* citydb.delete_feature(pid bigint) RETURNS BIGINT
* citydb.delete_property(bigint[]) RETURNS SETOF BIGINT
* citydb.delete_property(pid bigint) RETURNS BIGINT
* citydb.delete_geometry_data(bigint[]) RETURNS SETOF BIGINT
* citydb.delete_geometry_data(pid bigint) RETURNS BIGINT
* citydb.delete_implicit_geometry(bigint[]) RETURNS SETOF BIGINT
* citydb.delete_implicit_geometry(pid bigint) RETURNS BIGINT
* citydb.delete_appearance(bigint[]) RETURNS SETOF BIGINT
* citydb.delete_appearance(pid bigint) RETURNS BIGINT
* citydb.delete_surface_data(bigint[]) RETURNS SETOF BIGINT
* citydb.delete_surface_data(pid bigint) RETURNS BIGINT
* citydb.delete_tex_image(bigint[]) RETURNS SETOF BIGINT
* citydb.delete_tex_image(pid bigint) RETURNS BIGINT
* citydb.delete_address(bigint[]) RETURNS SETOF BIGINT
* citydb.delete_address(pid bigint) RETURNS BIGINT
******************************************************************/

/******************************************************************
* truncates all data tables
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.cleanup_schema() RETURNS SETOF void AS
$body$
DECLARE
rec RECORD;
BEGIN
FOR rec IN
SELECT table_name FROM information_schema.tables where table_schema = 'citydb'
        AND table_name <> 'ade'
        AND table_name <> 'datatype'
        AND table_name <> 'database_srs'
        AND table_name <> 'aggregation_info'
        AND table_name <> 'codelist'
        AND table_name <> 'codelist_entry'
        AND table_name <> 'namespace'
        AND table_name <> 'objectclass'
  LOOP
    EXECUTE format('TRUNCATE TABLE citydb.%I CASCADE', rec.table_name);
END LOOP;

FOR rec IN
SELECT sequence_name FROM information_schema.sequences where sequence_schema = 'citydb'
        AND sequence_name <> 'ade_seq'
  LOOP
    EXECUTE format('ALTER SEQUENCE citydb.%I RESTART', rec.sequence_name);
END LOOP;
END;
$body$
LANGUAGE plpgsql;

/******************************************************************
* delete from FEATURE table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.delete_feature(bigint[]) RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
  rec RECORD;
BEGIN
  PERFORM
    citydb.delete_property(array_agg(p.id))
  FROM
    citydb.property p,
    unnest($1) a(a_id)
  WHERE
    p.feature_id = a.a_id;

  WITH delete_objects AS (
    DELETE FROM
      citydb.feature f
    USING
      unnest($1) a(a_id)
    WHERE
      f.id = a.a_id
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from FEATURE table based on an id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.delete_feature(pid bigint) RETURNS BIGINT AS
$body$
DECLARE
  deleted_id bigint;
BEGIN
  deleted_id := citydb.delete_feature(ARRAY[pid]);
  RETURN deleted_id;
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from PROPERTY table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.delete_property(bigint[]) RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
  feature_ids bigint[] := '{}';
  geometry_ids bigint[] := '{}';
  implicit_geometry_ids bigint[] := '{}';
  appearance_ids bigint[] := '{}';
  address_ids bigint[] := '{}';
  rec RECORD;
BEGIN
  WITH child_refs AS (
    DELETE FROM
      citydb.property p
    USING
      unnest($1) a(a_id)
    WHERE
      p.root_id = a.a_id
    RETURNING
      p.id,
      p.val_feature_id,
      p.val_geometry_id,
      p.val_implicitgeom_id,
      p.val_appearance_id,
      p.val_address_id
  )
  SELECT
    array_agg(id),
    array_agg(val_feature_id),
    array_agg(val_geometry_id),
    array_agg(val_implicitgeom_id),
    array_agg(val_appearance_id),
    array_agg(val_address_id)
  INTO
    deleted_ids,
    feature_ids,
    geometry_ids,
    implicit_geometry_ids,
    appearance_ids,
    address_ids
  FROM
    child_refs;

  IF -1 = ALL(feature_ids) IS NOT NULL THEN
    PERFORM
      citydb.delete_feature(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(feature_ids) AS a_id) a
    LEFT JOIN
      citydb.property p
      ON p.val_feature_id  = a.a_id
    WHERE p.val_feature_id IS NULL AND (p.VAL_REFERENCE_TYPE IS NULL OR p.VAL_REFERENCE_TYPE <> 2);
  END IF;

  IF -1 = ALL(geometry_ids) IS NOT NULL THEN
    PERFORM
      citydb.delete_geometry_data(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(geometry_ids) AS a_id) a;
  END IF;

  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      citydb.delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a;
  END IF;

  IF -1 = ALL(appearance_ids) IS NOT NULL THEN
    PERFORM
      citydb.delete_appearance(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(appearance_ids) AS a_id) a;
  END IF;

  IF -1 = ALL(address_ids) IS NOT NULL THEN
    PERFORM
      citydb.delete_address(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(address_ids) AS a_id) a;
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from PROPERTY table based on an id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.delete_property(pid bigint) RETURNS BIGINT AS
$body$
DECLARE
  deleted_id bigint;
BEGIN
  deleted_id := citydb.delete_property(ARRAY[pid]);
  RETURN deleted_id;
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from GEOMETRY_DATA table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.delete_geometry_data(bigint[]) RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
  rec RECORD;
BEGIN
  WITH delete_objects AS (
    DELETE FROM
      citydb.geometry_data t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from GEOMETRY_DATA table based on an id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.delete_geometry_data(pid bigint) RETURNS BIGINT AS
$body$
DECLARE
  deleted_id bigint;
BEGIN
  deleted_id := citydb.delete_geometry_data(ARRAY[pid]);
  RETURN deleted_id;
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from IMPLICIT_GEOMETRY table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.delete_implicit_geometry(bigint[]) RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
  relative_geometry_ids bigint[] := '{}';
  appearance_ids bigint[] := '{}';
  rec RECORD;
BEGIN
  PERFORM
    citydb.delete_appearance(array_agg(t.id))
  FROM
    citydb.appearance t,
    unnest($1) a(a_id)
  WHERE
    t.implicit_geometry_id = a.a_id;

  WITH delete_objects AS (
    DELETE FROM
      citydb.implicit_geometry t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      relative_geometry_id
  )
  SELECT
    array_agg(id),
    array_agg(relative_geometry_id)
  INTO
    deleted_ids,
    relative_geometry_ids
  FROM
    delete_objects;

  IF -1 = ALL(relative_geometry_ids) IS NOT NULL THEN
    PERFORM
      citydb.delete_geometry_data(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(relative_geometry_ids) AS a_id) a;
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from IMPLICIT_GEOMETRY table based on an id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.delete_implicit_geometry(pid bigint) RETURNS BIGINT AS
$body$
DECLARE
  deleted_id bigint;
BEGIN
  deleted_id := citydb.delete_implicit_geometry(ARRAY[pid]);
  RETURN deleted_id;
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from APPEARANCE table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.delete_appearance(bigint[]) RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
  surface_data_ids bigint[] := '{}';
  rec RECORD;
BEGIN
  WITH surface_data_refs AS (
    DELETE FROM
      citydb.appear_to_surface_data t
    USING
      unnest($1) a(a_id)
    WHERE
      t.appearance_id = a.a_id
    RETURNING
      t.surface_data_id
  )
  SELECT
    array_agg(surface_data_id)
  INTO
    surface_data_ids
  FROM
    surface_data_refs;

  IF -1 = ALL(surface_data_ids) IS NOT NULL THEN
    PERFORM
      citydb.delete_surface_data(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_data_ids) AS a_id) a
    LEFT JOIN
      citydb.appear_to_surface_data atsd
      ON atsd.surface_data_id  = a.a_id
    WHERE atsd.surface_data_id IS NULL;
  END IF;

  WITH delete_objects AS (
    DELETE FROM
      citydb.appearance t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from APPEARANCE table based on an id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.delete_appearance(pid bigint) RETURNS BIGINT AS
$body$
DECLARE
  deleted_id bigint;
BEGIN
  deleted_id := citydb.delete_appearance(ARRAY[pid]);
  RETURN deleted_id;
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from SURFACE_DATA table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.delete_surface_data(bigint[]) RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
  tex_image_ids bigint[] := '{}';
  rec RECORD;
BEGIN
  WITH delete_objects AS (
    DELETE FROM
      citydb.surface_data t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      tex_image_id
  )
  SELECT
    array_agg(id),
    array_agg(tex_image_id)
  INTO
    deleted_ids,
    tex_image_ids
  FROM
    delete_objects;

  IF -1 = ALL(tex_image_ids) IS NOT NULL THEN
    PERFORM
      citydb.delete_tex_image(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(tex_image_ids) AS a_id) a
    LEFT JOIN
      citydb.surface_data sd
      ON sd.tex_image_id  = a.a_id
    WHERE sd.tex_image_id IS NULL;
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from SURFACE_DATA table based on an id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.delete_surface_data(pid bigint) RETURNS BIGINT AS
$body$
DECLARE
  deleted_id bigint;
BEGIN
  deleted_id := citydb.delete_surface_data(ARRAY[pid]);
  RETURN deleted_id;
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from TEX_IMAGE table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.delete_tex_image(bigint[]) RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
  rec RECORD;
BEGIN
  WITH delete_objects AS (
    DELETE FROM
      citydb.tex_image t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from TEX_IMAGE table based on an id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.delete_tex_image(pid bigint) RETURNS BIGINT AS
$body$
DECLARE
  deleted_id bigint;
BEGIN
  deleted_id := citydb.delete_tex_image(ARRAY[pid]);
  RETURN deleted_id;
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from ADDRESS table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.delete_address(bigint[]) RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
  rec RECORD;
BEGIN
  WITH delete_objects AS (
    DELETE FROM
      citydb.address t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from ADDRESS table based on an id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.delete_address(pid bigint) RETURNS BIGINT AS
$body$
DECLARE
  deleted_id bigint;
BEGIN
  deleted_id := citydb.del_address(ARRAY[pid]);
  RETURN deleted_id;
END;
$body$
LANGUAGE plpgsql STRICT;


