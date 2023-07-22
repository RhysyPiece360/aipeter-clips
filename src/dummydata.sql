-- Insert dummy data into the 'users' table
INSERT INTO users (username, email, pw, discordusername, bio)
VALUES
    ('user1', 'user1@example.com', 'password1', 'discorduser1', 'Bio for user1'),
    ('user2', 'user2@example.com', 'password2', 'discorduser2', 'Bio for user2'),
    ('user3', 'user3@example.com', 'password3', 'discorduser3', 'Bio for user3'),
    ('user4', 'user4@example.com', 'password4', 'discorduser4', 'Bio for user4'),
    ('user5', 'user5@example.com', 'password5', 'discorduser5', 'Bio for user5'),
    ('user6', 'user6@example.com', 'password6', 'discorduser6', 'Bio for user6'),
    ('user7', 'user7@example.com', 'password7', 'discorduser7', 'Bio for user7'),
    ('user8', 'user8@example.com', 'password8', 'discorduser8', 'Bio for user8'),
    ('user9', 'user9@example.com', 'password9', 'discorduser9', 'Bio for user9'),
    ('user10', 'user10@example.com', 'password10', 'discorduser10', 'Bio for user10');

-- Insert dummy data into the 'videos' table
INSERT INTO videos (channel, title, filename, userid)
VALUES
    ('PETER', 'Video 1 on PETER', 'video1.mp4', 1),
    ('PETER', 'Video 2 on PETER', 'video2.mp4', 2),
    ('DBZ', 'Video 3 on DBZ', 'video3.mp4', 3),
    ('DBZ', 'Video 4 on DBZ', 'video4.mp4', 4),
    ('PETER', 'Video 5 on PETER', 'video5.mp4', 5),
    ('PETER', 'Video 6 on PETER', 'video6.mp4', 6),
    ('DBZ', 'Video 7 on DBZ', 'video7.mp4', 7),
    ('DBZ', 'Video 8 on DBZ', 'video8.mp4', 8),
    ('PETER', 'Video 9 on PETER', 'video9.mp4', 9),
    ('PETER', 'Video 10 on PETER', 'video10.mp4', 10),
    ('DBZ', 'Video 11 on DBZ', 'video11.mp4', 1),
    ('DBZ', 'Video 12 on DBZ', 'video12.mp4', 2),
    ('PETER', 'Video 13 on PETER', 'video13.mp4', 3),
    ('PETER', 'Video 14 on PETER', 'video14.mp4', 4),
    ('DBZ', 'Video 15 on DBZ', 'video15.mp4', 5),
    ('DBZ', 'Video 16 on DBZ', 'video16.mp4', 6),
    ('PETER', 'Video 17 on PETER', 'video17.mp4', 7),
    ('PETER', 'Video 18 on PETER', 'video18.mp4', 8),
    ('DBZ', 'Video 19 on DBZ', 'video19.mp4', 9),
    ('DBZ', 'Video 20 on DBZ', 'video20.mp4', 10);

-- Insert dummy data into the 'comments' table
INSERT INTO comments (videoid, userid, text)
SELECT
    v.videoid,
    u.userid,
    'Comment ' || (row_number() OVER (PARTITION BY v.videoid)) || ' on video ' || v.videoid
FROM
    videos v
JOIN
    users u ON u.userid = v.userid
CROSS JOIN LATERAL
    generate_series(1, (RANDOM() * 6 + 4)::int) as s;

