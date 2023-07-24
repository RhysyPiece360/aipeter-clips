--- PostgreSQL

--- user table
CREATE TABLE users (
  userid SERIAL PRIMARY KEY,
  username VARCHAR(20) UNIQUE,
  role VARCHAR(63) DEFAULT NULL,
  email VARCHAR(254) UNIQUE NOT NULL,
  --- don't need pw if using discord for auth
  pw CHAR(60) NOT NULL,
  created TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  lastlogin TIMESTAMPTZ DEFAULT NOW(),
  discordusername VARCHAR(37),
  discordsnowflake BIGINT CHECK (discordsnowflake >= 0),
  bio TEXT,
  profilepic VARCHAR(32)
);

--- log user ips
--- TODO fail silently on update
--- TODO log after user login
CREATE TABLE user_ips (
  userid INT NOT NULL references users(userid),
  ip VARCHAR(45) NOT NULL,
  CONSTRAINT unique_userid_ip_pair UNIQUE (userid, ip)
);

--- list of shows with links
CREATE TABLE shows (
  shortname VARCHAR(6) PRIMARY KEY NOT NULL,
  fullname VARCHAR(32) NOT NULL,
  navname VARCHAR(16) NOT NULL,
  enabled BOOLEAN DEFAULT FALSE,
  discord VARCHAR(255),
  website VARCHAR(255),
  youtube VARCHAR(255),
  twitch VARCHAR(255),
  donationlink VARCHAR(255),
  otherlink VARCHAR(255),
  otherlinktype VARCHAR(255)
);

--- video table
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

--- video likes
--- if no userid is added, an ip and user agent must be provided to prevent spam
CREATE TABLE videolikes (
   videoid INT REFERENCES videos(videoid) NOT NULL,
   userid INT DEFAULT NULL REFERENCES users(userid),
   --- 45 allows for ipv4 mapped to ipv6
   ip VARCHAR(45),
   userAgent TEXT,
   --- allow logged in users, or log the ip and user agent to prevent spam
   CHECK (
     (userid IS NOT NULL) OR
     (ip IS NOT NULL AND user_agent IS NOT NULL)
   ),
   --- make sure that logged in users cannot like a post more than once
   UNIQUE (videoid, userid),
   --- same as above but with anonymous users
   UNIQUE (videoid, ip, userAgent)
);


CREATE TABLE comments (
  commentid SERIAL PRIMARY KEY,
  videoid INT REFERENCES videos (videoid),
  userid INT REFERENCES users (userid),
  text TEXT NOT NULL,
  posted TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  likes INT DEFAULT 0
);

--- function to return the full show name from a short name (do we need this?)
CREATE OR REPLACE FUNCTION fullShowName(input text)
RETURNS text AS
$$
DECLARE
  show_fullname text;
BEGIN
  -- Use SELECT query to retrieve the fullname from the 'shows' table based on the shortname
  SELECT fullname INTO show_fullname FROM shows WHERE shortname = 'input';
  
  RETURN show_fullname; -- This will return the show_fullname found in the table, or NULL if not found
END;
$$
LANGUAGE plpgsql;

/* CREATE TABLE commentlikes ( */
/*   commentid INT REFERENCES comments(commentid) NOT NULL, */
/*   userid INT DEFAULT NULL */
/* ); */

--- format timestamp for website
CREATE OR REPLACE FUNCTION formatTimestamp(timestamp_column timestamptz)
RETURNS TEXT AS
$$
BEGIN
  RETURN TO_CHAR(timestamp_column, 'Mon DD YYYY HH:MIAM');
END;
$$
LANGUAGE plpgsql;



--- OLD function to return the full show name from a short name
---CREATE OR REPLACE FUNCTION fullShowName(shortname text)
---RETURNS text AS
---$$
---BEGIN
---  RETURN CASE 
---    WHEN shortname = 'PETER' THEN 'AI Peter'
---    WHEN shortname = 'DBZ' THEN 'AI Dragon Ball'
---    WHEN shortname = 'SPONGE' THEN 'AI Sponge'
---    WHEN shortname = 'BRBA' THEN 'AI Breaking Bad'
---    ELSE NULL
---  END;
---END;
---$$
---LANGUAGE plpgsql;

--- view for staff
CREATE OR REPLACE VIEW staff AS
SELECT
  CASE role
    WHEN 'Owner' THEN 1
    WHEN 'Developer' THEN 25
    WHEN 'Admin' THEN 50
    WHEN 'Moderator' THEN 100
  END AS rankval,
  role,
  username,
  discordusername,
  discordsnowflake,
  userid
FROM USERS
WHERE role IS NOT NULL
ORDER BY rankval ASC, username ASC;
