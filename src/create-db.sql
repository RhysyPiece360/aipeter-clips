--- PostgreSQL

CREATE TABLE videos (
  videoid SMALLSERIAL PRIMARY KEY,
  title VARCHAR(255),
  filename VARCHAR(255) UNIQUE,
  uploaded TIMESTAMP NOT NULL DEFAULT NOW(),
  userid SMALLINT,
  likes SMALLINT 
)
  
CREATE TABLE users (
  userid SMALLSERIAL PRIMARY KEY,
  username VARCHAR(20) UNIQUE,
  email VARCHAR(255),
  pw BINARY(60),
  bio TEXT
);

CREATE TABLE comments (
  commentid SERIAL PRIMARY KEY,
  userid SMALLINT,
  data TEXT,
  likes SMALLINT,
  posted TIMESTAMP NOT NULL DEFAULT NOW()
); 
