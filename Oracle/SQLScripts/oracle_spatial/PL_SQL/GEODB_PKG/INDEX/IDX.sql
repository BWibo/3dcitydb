-- IDX.sql
--
-- Authors:     Claus Nagel <cnagel@virtualcitysystems.de>
--
-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
--              (c) 2007-2012  Institute for Geodesy and Geoinformation Science,
--                             Technische Universität Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Creates package "geodb_idx" containing utility methods for creating/droping
-- spatial/normal indexes on versioned/unversioned tables.
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 2.0.0     2014-07-30   new version for 3DCityDB V3                 FKun
-- 1.0.0     2008-09-10   release version                             CNag
--

/*****************************************************************
* TYPE INDEX_OBJ
* 
* global type to store information relevant to indexes
******************************************************************/
CREATE OR REPLACE TYPE INDEX_OBJ AS OBJECT
  (index_name VARCHAR2(30),
   table_name VARCHAR2(30),
   attribute_name VARCHAR2(30),
   type NUMBER(1),
   srid NUMBER,
   is_3d NUMBER(1, 0),
   schema_name VARCHAR2(30),
     STATIC function construct_spatial_3d
     (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, srid NUMBER := 0, schema_name VARCHAR2 := USER)
     RETURN INDEX_OBJ,
     STATIC function construct_spatial_2d
     (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, srid NUMBER := 0, schema_name VARCHAR2 := USER)
     RETURN INDEX_OBJ,
     STATIC function construct_normal
     (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, srid NUMBER := 0, schema_name VARCHAR2 := USER)
     RETURN INDEX_OBJ
  );
/

/*****************************************************************
* TYPE BODY INDEX_OBJ
* 
* constructors for INDEX_OBJ instances
******************************************************************/
CREATE OR REPLACE TYPE BODY INDEX_OBJ IS
  STATIC FUNCTION construct_spatial_3d
  (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, srid NUMBER := 0, schema_name VARCHAR2 := USER)
  RETURN INDEX_OBJ IS
  BEGIN
    RETURN INDEX_OBJ(upper(index_name), upper(table_name), upper(attribute_name), 1, srid, 1, schema_name);
  END;
  STATIC FUNCTION construct_spatial_2d
  (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, srid NUMBER := 0, schema_name VARCHAR2 := USER)
  RETURN INDEX_OBJ IS
  BEGIN
    RETURN INDEX_OBJ(upper(index_name), upper(table_name), upper(attribute_name), 1, srid, 0, schema_name);
  END;
  STATIC FUNCTION construct_normal
  (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, srid NUMBER := 0, schema_name VARCHAR2 := USER)
  RETURN INDEX_OBJ IS
  BEGIN
    RETURN INDEX_OBJ(upper(index_name), upper(table_name), upper(attribute_name), 0, srid, 0, schema_name);
  END;
END;
/


/******************************************************************
* INDEX_TABLE that holds INDEX_OBJ instances
* 
******************************************************************/
CREATE TABLE INDEX_TABLE (
  ID          NUMBER PRIMARY KEY,
  obj         INDEX_OBJ,
  schemaname  VARCHAR2(100)
);

CREATE SEQUENCE index_table_seq INCREMENT BY 1 START WITH 1 MINVALUE 1;

/******************************************************************
* Populate INDEX_TABLE with INDEX_OBJ instances
* 
******************************************************************/
INSERT INTO index_table (id, obj, schemaname) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_spatial_3d('CITYOBJECT_ENVELOPE_SPX', 'CITYOBJECT', 'ENVELOPE'), USER);
INSERT INTO index_table (id, obj, schemaname) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_spatial_3d('SURFACE_GEOM_SPX', 'SURFACE_GEOMETRY', 'GEOMETRY'), USER);
INSERT INTO index_table (id, obj, schemaname) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('CITYOBJECT_INX', 'CITYOBJECT', 'GMLID'), USER);
INSERT INTO index_table (id, obj, schemaname) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('SURFACE_GEOM_INX', 'SURFACE_GEOMETRY', 'GMLID'), USER);
INSERT INTO index_table (id, obj, schemaname) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('APPEARANCE_INX', 'APPEARANCE', 'GMLID'), USER);
INSERT INTO index_table (id, obj, schemaname) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('SURFACE_DATA_INX', 'SURFACE_DATA', 'GMLID'), USER);
COMMIT;

CREATE INDEX index_table_schema_idx ON index_table (schemaname);


/*****************************************************************
* PACKAGE geodb_idx
* 
* utility methods for index handling
******************************************************************/
CREATE OR REPLACE PACKAGE geodb_idx
AS
  FUNCTION index_status(idx INDEX_OBJ) RETURN VARCHAR2;
  FUNCTION index_status(table_name VARCHAR2, column_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION status_spatial_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY;
  FUNCTION status_normal_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY;
  FUNCTION create_index(idx INDEX_OBJ, is_versioned BOOLEAN, params VARCHAR2 := '') RETURN VARCHAR2;
  FUNCTION drop_index(idx INDEX_OBJ, is_versioned BOOLEAN) RETURN VARCHAR2;
  FUNCTION create_spatial_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY;
  FUNCTION drop_spatial_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY;
  FUNCTION create_normal_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY;
  FUNCTION drop_normal_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY;
  FUNCTION get_index(table_name VARCHAR2, column_name VARCHAR2, tab_schema_name VARCHAR2 := USER) RETURN INDEX_OBJ;
END geodb_idx;
/

CREATE OR REPLACE PACKAGE BODY geodb_idx
AS 
  NORMAL CONSTANT NUMBER(1) := 0;
  SPATIAL CONSTANT NUMBER(1) := 1;

  /*****************************************************************
  * index_status
  * 
  * @param idx index to retrieve status from
  * @return VARCHAR2 string representation of status, may include
  *                  'DROPPED', 'VALID', 'FAILED', 'INVALID'
  ******************************************************************/
  FUNCTION index_status(idx INDEX_OBJ) RETURN VARCHAR2
  IS
    status VARCHAR2(20);
  BEGIN
    IF idx.type = SPATIAL THEN
      EXECUTE IMMEDIATE 'select upper(DOMIDX_OPSTATUS) from ALL_INDEXES where OWNER=:1 and INDEX_NAME=:2' INTO status USING idx.schema_name, idx.index_name;
    ELSE
      EXECUTE IMMEDIATE 'select upper(STATUS) from ALL_INDEXES where OWNER=:1 and INDEX_NAME=:2' INTO status USING idx.schema_name, idx.index_name;
    END IF;

    RETURN status;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'DROPPED';
    WHEN others THEN
      RETURN 'INVALID';
  END;

  /*****************************************************************
  * index_status
  * 
  * @param table_name table_name of index to retrieve status from
  * @param column_name column_name of index to retrieve status from
  * @param schema_name schema_name of index to retrieve status from
  * @return VARCHAR2 string representation of status, may include
  *                  'DROPPED', 'VALID', 'FAILED', 'INVALID'
  ******************************************************************/
  FUNCTION index_status(
    table_name VARCHAR2, 
    column_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2
  IS
    internal_table_name VARCHAR2(100);
    index_type VARCHAR2(35);
    index_name VARCHAR2(35);
    status VARCHAR2(20);
  BEGIN
    internal_table_name := table_name;

    IF geodb_util.versioning_table(table_name) = 'ON' THEN
      internal_table_name := table_name || '_LT';
    END IF;     

    EXECUTE IMMEDIATE 'select upper(INDEX_TYPE), INDEX_NAME from ALL_INDEXES where INDEX_NAME=
    	(select upper(INDEX_NAME) from ALL_IND_COLUMNS where OWNER=:1 and TABLE_NAME=:2 and COLUMN_NAME=:3)' 
    	INTO index_type, index_name USING upper(schema_name), upper(internal_table_name), upper(column_name);  

    IF index_type = 'DOMAIN' THEN
      EXECUTE IMMEDIATE 'select upper(DOMIDX_OPSTATUS) FROM ALL_INDEXES where OWNER=:1 and INDEX_NAME=:2' INTO status USING schema_name, index_name;
    ELSE
      EXECUTE IMMEDIATE 'select upper(STATUS) FROM ALL_INDEXES where OWNER=:1 and INDEX_NAME=:2' INTO status USING schema_name, index_name;
    END IF;

    RETURN status;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'DROPPED';
    WHEN others THEN
      RETURN 'INVALID';
  END;

  /*****************************************************************
  * create_spatial_metadata
  * 
  * @param idx index to create metadata for
  * @param is_versioned TRUE if database table is version-enabled
  ******************************************************************/
  PROCEDURE create_spatial_metadata(
    idx INDEX_OBJ, 
    is_versioned BOOLEAN
    )
  IS
    table_name VARCHAR2(100);
    srid DATABASE_SRS.SRID%TYPE;
  BEGIN
    table_name := idx.table_name;

    IF is_versioned THEN
      table_name := table_name || '_LT';
    END IF;    

    EXECUTE IMMEDIATE 'delete from USER_SDO_GEOM_METADATA where TABLE_NAME=:1 and COLUMN_NAME=:2' USING table_name, idx.attribute_name;

    IF idx.srid = 0 THEN
      EXECUTE IMMEDIATE 'select SRID from DATABASE_SRS' INTO srid;
    ELSE
      srid := idx.srid;
    END IF;

    IF idx.is_3d = 0 THEN
      EXECUTE IMMEDIATE 'INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
                          VALUES (:1, :2,
                            MDSYS.SDO_DIM_ARRAY 
                            (
                              MDSYS.SDO_DIM_ELEMENT(''X'', 0.000, 10000000.000, 0.0005), 
                              MDSYS.SDO_DIM_ELEMENT(''Y'', 0.000, 10000000.000, 0.0005)), :3
                            )' USING table_name, idx.attribute_name, srid;
    ELSE
      EXECUTE IMMEDIATE 'INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
                          VALUES (:1, :2,
                            MDSYS.SDO_DIM_ARRAY 
                            (
                              MDSYS.SDO_DIM_ELEMENT(''X'', 0.000, 10000000.000, 0.0005), 
                              MDSYS.SDO_DIM_ELEMENT(''Y'', 0.000, 10000000.000, 0.0005),
                              MDSYS.SDO_DIM_ELEMENT(''Z'', -1000, 10000, 0.0005)), :3
                            )' USING table_name, idx.attribute_name, srid;
    END IF;    
  END;

  /*****************************************************************
  * create_index
  * 
  * @param idx index to create
  * @param is_versioned TRUE if database table is version-enabled
  * @return VARCHAR2 sql error code, 0 for no errors
  ******************************************************************/
  FUNCTION create_index(idx INDEX_OBJ,
    is_versioned BOOLEAN, 
    params VARCHAR2 := ''
    ) RETURN VARCHAR2
  IS
    create_ddl VARCHAR2(1000);
    table_name VARCHAR2(100);
    sql_err_code VARCHAR2(20);
  BEGIN    
    IF index_status(idx) <> 'VALID' THEN
      sql_err_code := drop_index(idx, is_versioned);

      BEGIN
        table_name := idx.table_name;

        IF is_versioned THEN
          dbms_wm.BEGINDDL(idx.table_name);
          table_name := table_name || '_LTS';
        END IF;

        create_ddl := 'CREATE INDEX ' || idx.index_name || ' ON ' || idx.schema_name || '.' || table_name || '(' || idx.attribute_name || ')';

        IF idx.type = SPATIAL THEN
          create_spatial_metadata(idx, is_versioned);
          create_ddl := create_ddl || ' INDEXTYPE is MDSYS.SPATIAL_INDEX';
        END IF;

        IF params <> '' THEN
          create_ddl := create_ddl || ' ' || params;
        END IF;

        EXECUTE IMMEDIATE create_ddl;

        IF is_versioned THEN
          dbms_wm.COMMITDDL(idx.table_name);
        END IF;

      EXCEPTION
        WHEN others THEN
          dbms_output.put_line(SQLERRM);

          IF is_versioned THEN
            dbms_wm.ROLLBACKDDL(idx.table_name);
          END IF;

          RETURN SQLCODE;
      END;
    END IF;
    
    RETURN '0';
  END;
  
  /*****************************************************************
  * drop_index
  * 
  * @param idx index to drop
  * @param is_versioned TRUE if database table is version-enabled
  * @return VARCHAR2 sql error code, 0 for no errors
  ******************************************************************/
  FUNCTION drop_index(
    idx INDEX_OBJ, 
    is_versioned BOOLEAN
    ) RETURN VARCHAR2
  IS
    index_name VARCHAR2(100);
  BEGIN
    IF index_status(idx) <> 'DROPPED' THEN
      BEGIN
        index_name := idx.index_name;

        IF is_versioned THEN
          dbms_wm.BEGINDDL(idx.table_name);
          index_name := index_name || '_LTS';
        END IF;

        EXECUTE IMMEDIATE 'DROP INDEX ' || idx.schema_name || '.' || index_name;

        IF is_versioned THEN
          dbms_wm.COMMITDDL(idx.table_name);
        END IF;
      EXCEPTION
        WHEN others THEN
          dbms_output.put_line(SQLERRM);

          IF is_versioned THEN
            dbms_wm.ROLLBACKDDL(idx.table_name);
          END IF;

          RETURN SQLCODE;
      END;
    END IF;
    
    RETURN '0';
  END;

  /*****************************************************************
  * create_indexes
  * private convenience method for invoking create_index on indexes 
  * of same index type
  * 
  * @param type type of index, e.g. SPATIAL or NORMAL
  * @param schema_name target schema for indexes to be created
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION create_indexes(
    type SMALLINT, 
    schema_name VARCHAR2 := USER
    ) RETURN STRARRAY
  IS
    log STRARRAY;
    sql_error_code VARCHAR2(20);
  BEGIN
    log := STRARRAY();

    FOR rec IN (SELECT * FROM index_table WHERE schemaname = upper(schema_name)) LOOP
      IF rec.obj.type = type THEN
        sql_error_code := create_index(rec.obj, geodb_util.versioning_table(rec.obj.table_name) = 'ON');
        log.extend;
        log(log.count) := index_status(rec.obj) || ':' || rec.obj.index_name || ':' || rec.obj.schema_name || ':' || rec.obj.table_name || ':' || rec.obj.attribute_name || ':' || sql_error_code;
      END IF;
    END LOOP;

    RETURN log;
  END;
  
  /*****************************************************************
  * drop_indexes
  * private convenience method for invoking drop_index on indexes 
  * of same index type
  * 
  * @param type type of index, e.g. SPATIAL or NORMAL
  * @param schema_name target schema for indexes to be dropped
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION drop_indexes(type SMALLINT, schema_name VARCHAR2 := USER) RETURN STRARRAY
  IS
    log STRARRAY;
    sql_error_code VARCHAR2(20);
  BEGIN
    log := STRARRAY();
    
    FOR rec IN (SELECT * FROM index_table WHERE schemaname = upper(schema_name)) LOOP
      IF rec.obj.type = type THEN
        sql_error_code := drop_index(rec.obj, geodb_util.versioning_table(rec.obj.table_name) = 'ON');
        log.extend;
        log(log.count) := index_status(rec.obj) || ':' || rec.obj.index_name || ':' || rec.obj.schema_name || ':' || rec.obj.table_name || ':' || rec.obj.attribute_name || ':' || sql_error_code;
      END IF;
    END LOOP; 

    RETURN log;
  END;

  /*****************************************************************
  * status_spatial_indexes
  * 
  * @param schema_name target schema of indexes to retrieve status from
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION status_spatial_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY
  IS
    log STRARRAY;
    status VARCHAR2(20);
  BEGIN
    log := STRARRAY();

    FOR rec IN (SELECT * FROM index_table WHERE schemaname = upper(schema_name)) LOOP
      IF rec.obj.type = SPATIAL THEN
        status := index_status(rec.obj);
        log.extend;
        log(log.count) := status || ':' || rec.obj.index_name || ':' || rec.obj.schema_name || ':' || rec.obj.table_name || ':' || rec.obj.attribute_name;
      END IF;
    END LOOP;

    RETURN log;
  END;

  /*****************************************************************
  * status_normal_indexes
  * 
  * @param schema_name target schema of indexes to retrieve status from
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION status_normal_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY
  IS
    log STRARRAY;
    status VARCHAR2(20);
  BEGIN
    log := STRARRAY();

    FOR rec IN (SELECT * FROM index_table WHERE schemaname = upper(schema_name)) LOOP
      IF rec.obj.type = NORMAL THEN
        status := index_status(rec.obj);
        log.extend;
        log(log.count) := status || ':' || rec.obj.index_name || ':' || rec.obj.schema_name || ':' || rec.obj.table_name || ':' || rec.obj.attribute_name;
      END IF;
    END LOOP;

    RETURN log;
  END;

  /*****************************************************************
  * create_spatial_indexes
  * convenience method for invoking create_index on all spatial indexes 
  * 
  * @param schema_name target schema for indexes to be created
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION create_spatial_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY
  IS
  BEGIN
    dbms_output.enable;
    RETURN create_indexes(SPATIAL, upper(schema_name));
  END;

  /*****************************************************************
  * drop_spatial_indexes
  * convenience method for invoking drop_index on all spatial indexes 
  * 
  * @param schema_name target schema for indexes to be dropped
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION drop_spatial_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY
  IS
  BEGIN
    dbms_output.enable;
    RETURN drop_indexes(SPATIAL, upper(schema_name));
  END;

  /*****************************************************************
  * create_normal_indexes
  * convenience method for invoking create_index on all normal indexes 
  * 
  * @param schema_name target schema for indexes to be created
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION create_normal_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY
  IS
  BEGIN
    dbms_output.enable;
    RETURN create_indexes(NORMAL, upper(schema_name));
  END;

  /*****************************************************************
  * drop_normal_indexes
  * convenience method for invoking drop_index on all normal indexes 
  * 
  * @param schema_name target schema for indexes to be dropped
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION drop_normal_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY
  IS
  BEGIN
    dbms_output.enable;
    RETURN drop_indexes(NORMAL, upper(schema_name));
  END;

  /*****************************************************************
  * get_index
  * convenience method for getting an index object 
  * given the schema.table and column it indexes
  * 
  * @param table_name
  * @param attribute_name
  * @param tab_schema_name
  * @return INDEX_OBJ
  ******************************************************************/
  FUNCTION get_index(
    table_name VARCHAR2, 
    column_name VARCHAR2,
    tab_schema_name VARCHAR2 := USER
	) RETURN INDEX_OBJ
  IS
    idx INDEX_OBJ;
  BEGIN
    FOR rec IN (SELECT * FROM index_table WHERE schemaname = upper(tab_schema_name)) LOOP
      IF rec.obj.attribute_name = upper(column_name) AND rec.obj.table_name = upper(table_name) THEN
        idx := rec.obj;
        EXIT;
      END IF;
    END LOOP;

    RETURN idx;
  END;
END geodb_idx;
/