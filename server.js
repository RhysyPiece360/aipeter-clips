const path = require('node:path')

const SITEURL = new URL('http://10.0.0.187:3420')

// set express stuffs tbh
const express = require('express')
const app = express()
const port = 3420
app.set('view engine', 'pug')
app.use('/public', express.static(path.join(__dirname, 'public')))

// where to store videos + video endpoint
const VIDEOSDIR = path.resolve('./videos/')
app.use('/api/video', express.static(VIDEOSDIR))

// .env config
require('dotenv').config()
console.log(process.env)

const { Pool } = require('pg')
const pool = new Pool({
  user: process.env.PGUSER,
  host: process.env.PGHOST,
  database: process.env.PGDATABASE,
  password: process.env.PGPASSWORD,
  port: process.env.PGPORT,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
})

const sqlDriver = {
  postLimit: 10,
  homepagePostLimit: 6,
  homepagePosts: function() {
    console.log('this will get homepage posts')
    return `SELECT videos.*, users.username
    FROM videos
    JOIN users ON videos.userid = users.userid
    ORDER BY uploaded DESC
    LIMIT ${this.homepagePostLimit};`
  },
  // user pages, accepts userid
  userPageID: function(userid) {
    console.log('this will get the info needed for user page')
    return `PREPARE userPage (int) AS
    SELECT userid, username, discordusername, created, bio
    FROM users
    WHERE userid = $1;
    EXECUTE userPage(${userid});`
  },
  aiShowPage: function(show) {
    console.log('this will get videos for `show`')
    

  }
}


// fancy formatting for show names
const fancyFmtShowName = showName => {
  switch (showName) {
    case 'PETER': return 'AI Peter';
    case 'DBZ': return 'AI Dragon Ball';
  }
}

// homepage
app.get('/', async (req, res) => {
  try {
    const sqlRes = await pool.query(sqlDriver.homepagePosts())
    console.log(sqlRes.rows)

    for (post of sqlRes.rows) {
      post.fancyShowName = fancyFmtShowName(post.show);
    }

    res.render('index', {
      title: 'wabangus tbh',
      featuredPosts: sqlRes.rows
    })
  } catch (err) {
    // TODO error handling
    console.error(err)
  }
})


// start the server
app.listen(port, () => console.log(`ai_peter clips server listening on port ${port}`))
