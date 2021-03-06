/* Create and seed a manifest table for the engagement events job.
*/

-- Create the table if it doesn't exist
CREATE TABLE IF NOT EXISTS {{.output_schema}}.engagement_manifest (
  etl_tstamp TIMESTAMP ENCODE ZSTD,
  CONSTRAINT {{.output_schema}}_engagement_manifest_pk PRIMARY KEY(etl_tstamp)
)
DISTSTYLE ALL
SORTKEY(etl_tstamp);

-- Seed the manifest table
INSERT INTO {{.output_schema}}.engagement_manifest(etl_tstamp) (
  SELECT
    MIN(etl_tstamp)
  FROM
    {{.input_schema}}.events
  WHERE
    DATE_TRUNC('day', etl_tstamp) = DATE_TRUNC('day', '{{.start_date}}'::TIMESTAMP)
);