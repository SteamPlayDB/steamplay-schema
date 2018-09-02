-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.2-alpha
-- PostgreSQL version: 10.0
-- Project Site: pgmodeler.io
-- Model Author: ---


-- Database creation must be done outside a multicommand file.
-- These commands were put in this file only as a convenience.
-- -- object: steamplaydb | type: DATABASE --
-- -- DROP DATABASE IF EXISTS steamplaydb;
-- CREATE DATABASE steamplaydb;
-- -- ddl-end --
-- 

-- object: app | type: SCHEMA --
-- DROP SCHEMA IF EXISTS app CASCADE;
CREATE SCHEMA app;
-- ddl-end --
ALTER SCHEMA app OWNER TO postgres;
-- ddl-end --

-- object: steam | type: SCHEMA --
-- DROP SCHEMA IF EXISTS steam CASCADE;
CREATE SCHEMA steam;
-- ddl-end --
ALTER SCHEMA steam OWNER TO postgres;
-- ddl-end --

-- object: os | type: SCHEMA --
-- DROP SCHEMA IF EXISTS os CASCADE;
CREATE SCHEMA os;
-- ddl-end --
ALTER SCHEMA os OWNER TO postgres;
-- ddl-end --

-- object: hardware | type: SCHEMA --
-- DROP SCHEMA IF EXISTS hardware CASCADE;
CREATE SCHEMA hardware;
-- ddl-end --
ALTER SCHEMA hardware OWNER TO postgres;
-- ddl-end --

SET search_path TO pg_catalog,public,app,steam,os,hardware;
-- ddl-end --

-- object: app."user" | type: TABLE --
-- DROP TABLE IF EXISTS app."user" CASCADE;
CREATE TABLE app."user"(
	id uuid NOT NULL,
	username text NOT NULL,
	password_md5_aes smallint NOT NULL,
	detail_crypt jsonb,
	CONSTRAINT user_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE app."user" OWNER TO postgres;
-- ddl-end --

-- object: steam.app | type: TABLE --
-- DROP TABLE IF EXISTS steam.app CASCADE;
CREATE TABLE steam.app(
	id uuid NOT NULL,
	appid integer NOT NULL,
	name text NOT NULL,
	CONSTRAINT apps_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE steam.app OWNER TO postgres;
-- ddl-end --

-- object: app.report | type: TABLE --
-- DROP TABLE IF EXISTS app.report CASCADE;
CREATE TABLE app.report(
	id uuid NOT NULL,
	is_playable bool,
	is_completable bool,
	rating_performance int2 NOT NULL,
	rating_stability int2 NOT NULL,
	driver_type char,
	driver_version decimal,
	notes jsonb,
	id_user uuid,
	id_app uuid,
	id_distro uuid,
	id_gpu uuid,
	id_cpu uuid,
	CONSTRAINT activity_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE app.report OWNER TO postgres;
-- ddl-end --

-- object: app.bump | type: TABLE --
-- DROP TABLE IF EXISTS app.bump CASCADE;
CREATE TABLE app.bump(
	id uuid NOT NULL,
	timeof timestamp,
	id_user uuid,
	id_app uuid,
	CONSTRAINT bump_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE app.bump OWNER TO postgres;
-- ddl-end --

-- object: user_fk | type: CONSTRAINT --
-- ALTER TABLE app.bump DROP CONSTRAINT IF EXISTS user_fk CASCADE;
ALTER TABLE app.bump ADD CONSTRAINT user_fk FOREIGN KEY (id_user)
REFERENCES app."user" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: app_fk | type: CONSTRAINT --
-- ALTER TABLE app.bump DROP CONSTRAINT IF EXISTS app_fk CASCADE;
ALTER TABLE app.bump ADD CONSTRAINT app_fk FOREIGN KEY (id_app)
REFERENCES steam.app (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: user_fk | type: CONSTRAINT --
-- ALTER TABLE app.report DROP CONSTRAINT IF EXISTS user_fk CASCADE;
ALTER TABLE app.report ADD CONSTRAINT user_fk FOREIGN KEY (id_user)
REFERENCES app."user" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: app_fk | type: CONSTRAINT --
-- ALTER TABLE app.report DROP CONSTRAINT IF EXISTS app_fk CASCADE;
ALTER TABLE app.report ADD CONSTRAINT app_fk FOREIGN KEY (id_app)
REFERENCES steam.app (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: os.distro | type: TABLE --
-- DROP TABLE IF EXISTS os.distro CASCADE;
CREATE TABLE os.distro(
	id uuid NOT NULL,
	name text NOT NULL,
	version decimal,
	CONSTRAINT distro_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE os.distro OWNER TO postgres;
-- ddl-end --

-- object: hardware.gpu | type: TABLE --
-- DROP TABLE IF EXISTS hardware.gpu CASCADE;
CREATE TABLE hardware.gpu(
	id uuid NOT NULL,
	manufacturer text NOT NULL,
	model text NOT NULL,
	CONSTRAINT gpu_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE hardware.gpu OWNER TO postgres;
-- ddl-end --

-- object: hardware.cpu | type: TABLE --
-- DROP TABLE IF EXISTS hardware.cpu CASCADE;
CREATE TABLE hardware.cpu(
	id uuid NOT NULL,
	manufacturer text NOT NULL,
	model text NOT NULL,
	CONSTRAINT cpu_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE hardware.cpu OWNER TO postgres;
-- ddl-end --

-- object: distro_fk | type: CONSTRAINT --
-- ALTER TABLE app.report DROP CONSTRAINT IF EXISTS distro_fk CASCADE;
ALTER TABLE app.report ADD CONSTRAINT distro_fk FOREIGN KEY (id_distro)
REFERENCES os.distro (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: gpu_fk | type: CONSTRAINT --
-- ALTER TABLE app.report DROP CONSTRAINT IF EXISTS gpu_fk CASCADE;
ALTER TABLE app.report ADD CONSTRAINT gpu_fk FOREIGN KEY (id_gpu)
REFERENCES hardware.gpu (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: cpu_fk | type: CONSTRAINT --
-- ALTER TABLE app.report DROP CONSTRAINT IF EXISTS cpu_fk CASCADE;
ALTER TABLE app.report ADD CONSTRAINT cpu_fk FOREIGN KEY (id_cpu)
REFERENCES hardware.cpu (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: app.log | type: TABLE --
-- DROP TABLE IF EXISTS app.log CASCADE;
CREATE TABLE app.log(
	id uuid NOT NULL,
	event jsonb NOT NULL,
	id_user uuid,
	CONSTRAINT log_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE app.log OWNER TO postgres;
-- ddl-end --

-- object: user_fk | type: CONSTRAINT --
-- ALTER TABLE app.log DROP CONSTRAINT IF EXISTS user_fk CASCADE;
ALTER TABLE app.log ADD CONSTRAINT user_fk FOREIGN KEY (id_user)
REFERENCES app."user" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: log_index_id_user | type: INDEX --
-- DROP INDEX IF EXISTS app.log_index_id_user CASCADE;
CREATE INDEX log_index_id_user ON app.log
	USING btree
	(
	  id_user
	);
-- ddl-end --

-- object: report_index_id_user | type: INDEX --
-- DROP INDEX IF EXISTS app.report_index_id_user CASCADE;
CREATE INDEX report_index_id_user ON app.report
	USING btree
	(
	  id_user
	);
-- ddl-end --

-- object: report_index_id_app | type: INDEX --
-- DROP INDEX IF EXISTS app.report_index_id_app CASCADE;
CREATE INDEX report_index_id_app ON app.report
	USING btree
	(
	  id_app
	);
-- ddl-end --

-- object: bump_index_id_user | type: INDEX --
-- DROP INDEX IF EXISTS app.bump_index_id_user CASCADE;
CREATE INDEX bump_index_id_user ON app.bump
	USING btree
	(
	  id_user ASC NULLS LAST
	);
-- ddl-end --

-- object: bump_index_id_app | type: INDEX --
-- DROP INDEX IF EXISTS app.bump_index_id_app CASCADE;
CREATE INDEX bump_index_id_app ON app.bump
	USING btree
	(
	  id_app
	);
-- ddl-end --

-- object: user_index_id | type: INDEX --
-- DROP INDEX IF EXISTS app.user_index_id CASCADE;
CREATE INDEX user_index_id ON app."user"
	USING btree
	(
	  id
	);
-- ddl-end --

-- object: user_index_username | type: INDEX --
-- DROP INDEX IF EXISTS app.user_index_username CASCADE;
CREATE INDEX user_index_username ON app."user"
	USING btree
	(
	  username
	);
-- ddl-end --

-- object: app_index_id | type: INDEX --
-- DROP INDEX IF EXISTS steam.app_index_id CASCADE;
CREATE INDEX app_index_id ON steam.app
	USING btree
	(
	  id
	);
-- ddl-end --

-- object: app_index_appid | type: INDEX --
-- DROP INDEX IF EXISTS steam.app_index_appid CASCADE;
CREATE INDEX app_index_appid ON steam.app
	USING btree
	(
	  appid
	);
-- ddl-end --

-- object: app_index_name | type: INDEX --
-- DROP INDEX IF EXISTS steam.app_index_name CASCADE;
CREATE INDEX app_index_name ON steam.app
	USING btree
	(
	  name
	);
-- ddl-end --


