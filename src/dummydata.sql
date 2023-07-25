-- Insert dummy data into the 'users' table with randomized created timestamps
INSERT INTO users (username, email, pw, discordusername, bio, created)
VALUES
    ('user1', 'user1@example.com', 'password1', 'discorduser1', 'Bio for user1', NOW() - INTERVAL '1 day' * RANDOM()),
    ('user2', 'user2@example.com', 'password2', 'discorduser2', 'Bio for user2', NOW() - INTERVAL '2 days' * RANDOM()),
    ('user3', 'user3@example.com', 'password3', 'discorduser3', 'Bio for user3', NOW() - INTERVAL '3 days' * RANDOM()),
    ('user4', 'user4@example.com', 'password4', 'discorduser4', 'Bio for user4', NOW() - INTERVAL '4 days' * RANDOM()),
    ('user5', 'user5@example.com', 'password5', 'discorduser5', 'Bio for user5', NOW() - INTERVAL '5 days' * RANDOM()),
    ('user6', 'user6@example.com', 'password6', 'discorduser6', 'Bio for user6', NOW() - INTERVAL '6 days' * RANDOM()),
    ('user7', 'user7@example.com', 'password7', 'discorduser7', 'Bio for user7', NOW() - INTERVAL '7 days' * RANDOM()),
    ('user8', 'user8@example.com', 'password8', 'discorduser8', 'Bio for user8', NOW() - INTERVAL '8 days' * RANDOM()),
    ('user9', 'user9@example.com', 'password9', 'discorduser9', 'Bio for user9', NOW() - INTERVAL '9 days' * RANDOM()),
    ('user10', 'user10@example.com', 'password10', 'discorduser10', 'Bio for user10', NOW() - INTERVAL '10 days' * RANDOM());

-- Insert dummy data into the 'videos' table with randomized uploaded timestamps
INSERT INTO videos (channel, title, filename, userid, uploaded)
VALUES
    ('PETER', 'Video 1 on PETER', 'video1.mp4', 1, NOW() - INTERVAL '1 day' * RANDOM()),
    ('PETER', 'Video 2 on PETER', 'video2.mp4', 2, NOW() - INTERVAL '2 days' * RANDOM()),
    ('DBZ', 'Video 3 on DBZ', 'video3.mp4', 3, NOW() - INTERVAL '3 days' * RANDOM()),
    ('DBZ', 'Video 4 on DBZ', 'video4.mp4', 4, NOW() - INTERVAL '4 days' * RANDOM()),
    ('PETER', 'Video 5 on PETER', 'video5.mp4', 5, NOW() - INTERVAL '5 days' * RANDOM()),
    ('PETER', 'Video 6 on PETER', 'video6.mp4', 6, NOW() - INTERVAL '6 days' * RANDOM()),
    ('DBZ', 'Video 7 on DBZ', 'video7.mp4', 7, NOW() - INTERVAL '7 days' * RANDOM()),
    ('DBZ', 'Video 8 on DBZ', 'video8.mp4', 8, NOW() - INTERVAL '8 days' * RANDOM()),
    ('PETER', 'Video 9 on PETER', 'video9.mp4', 9, NOW() - INTERVAL '9 days' * RANDOM()),
    ('PETER', 'Video 10 on PETER', 'video10.mp4', 10, NOW() - INTERVAL '10 days' * RANDOM()),
    ('DBZ', 'Video 11 on DBZ', 'video11.mp4', 1, NOW() - INTERVAL '11 days' * RANDOM()),
    ('DBZ', 'Video 12 on DBZ', 'video12.mp4', 2, NOW() - INTERVAL '12 days' * RANDOM()),
    ('PETER', 'Video 13 on PETER', 'video13.mp4', 3, NOW() - INTERVAL '13 days' * RANDOM()),
    ('PETER', 'Video 14 on PETER', 'video14.mp4', 4, NOW() - INTERVAL '14 days' * RANDOM()),
    ('DBZ', 'Video 15 on DBZ', 'video15.mp4', 5, NOW() - INTERVAL '15 days' * RANDOM()),
    ('DBZ', 'Video 16 on DBZ', 'video16.mp4', 6, NOW() - INTERVAL '16 days' * RANDOM()),
    ('PETER', 'Video 17 on PETER', 'video17.mp4', 7, NOW() - INTERVAL '17 days' * RANDOM()),
    ('PETER', 'Video 18 on PETER', 'video18.mp4', 8, NOW() - INTERVAL '18 days' * RANDOM()),
    ('DBZ', 'Video 19 on DBZ', 'video19.mp4', 9, NOW() - INTERVAL '19 days' * RANDOM()),
    ('DBZ', 'Video 20 on DBZ', 'video20.mp4', 10, NOW() - INTERVAL '20 days' * RANDOM());

-- Insert dummy data into the 'comments' table with randomized posted timestamps
INSERT INTO comments (videoid, userid, text, posted)
SELECT
    v.videoid,
    u.userid,
    'Comment ' || (row_number() OVER (PARTITION BY v.videoid)) || ' on video ' || v.videoid,
    NOW() - INTERVAL '1 day' * (RANDOM() * 9)
FROM
    videos v
JOIN
    users u ON u.userid = v.userid
CROSS JOIN LATERAL
    generate_series(1, (RANDOM() * 6 + 4)::int) as s;
