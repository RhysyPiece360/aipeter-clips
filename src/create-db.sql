--- PostgreSQL

CREATE TABLE videos (
  videoid SERIAL PRIMARY KEY,
  title VARCHAR(255),
  filename VARCHAR(255) UNIQUE,
  uploaded TIMESTAMP NOT NULL DEFAULT current_timestamp
)
  


CREATE TABLE users (
  userid SERIAL PRIMARY KEY,
  username VARCHAR(20) UNIQUE,
  email VARCHAR(255),
  bio TEXT
);
