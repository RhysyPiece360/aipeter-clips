--- PostgreSQL

CREATE TABLE users (
  userid SERIAL PRIMARY KEY,
  username VARCHAR(20) UNIQUE,
  email VARCHAR(254) UNIQUE NOT NULL,
  pw CHAR(60) NOT NULL,
  created TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  discordusername VARCHAR(37),
  bio TEXT
);

CREATE TABLE videos (
  videoid SERIAL PRIMARY KEY,
  channel VARCHAR(255) NOT NULL CHECK (channel = UPPER(channel)),
  title VARCHAR(255) NOT NULL,
  description VARCHAR(64),
  filename VARCHAR(255) UNIQUE NOT NULL,
  uploaded TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  userid INT NOT NULL REFERENCES users (userid),
  likes INT DEFAULT 0
);

CREATE TABLE comments (
  commentid SERIAL PRIMARY KEY,
  videoid INT REFERENCES videos (videoid),
  userid INT REFERENCES users (userid),
  text TEXT NOT NULL,
  posted TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  likes INT DEFAULT 0
);

CREATE OR REPLACE FUNCTION formatTimestamp(timestamp_column timestamptz)
RETURNS TEXT AS
$$
BEGIN
  RETURN TO_CHAR(timestamp_column, 'Mon DD YYYY HH:MIAM');
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fullShowName(shortname text)
RETURNS text AS
$$
BEGIN
  RETURN CASE 
    WHEN shortname = 'PETER' THEN 'AI Peter'
    WHEN shortname = 'DBZ' THEN 'AI Dragon Ball'
    ELSE NULL
  END;
END;
$$
LANGUAGE plpgsql;


/* CREATE TABLE videolikes ( */
/*   videoid INT REFERENCES videos(videoid) NOT NULL, */
/*   userid INT DEFAULT NULL */
/* ) */

/* CREATE TABLE commentlikes ( */
/*   commentid INT REFERENCES comments(commentid) NOT NULL, */
/*   userid INT DEFAULT NULL */
/* ) */
