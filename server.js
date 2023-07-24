const path = require('node:path')

const SITEURL = new URL('http://10.0.0.187:3420')

const crypto = require('node:crypto')

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

const poweredBy = () => {
  const list = [
    'sex on tv',
    'child slave labor',
    'cum',
    'your parent\'s failed marriage',
    'SAMSUNG',
    'a hamster on one of those spinny wheel things',
    'Procrastination™',
    'Walter White',
    'Walter White\'s meth',
    '\'*\'',
    'hot babes in your area!',
    'aliens',
    'why do I exist juice',
    'Owner\'s cat',
    'erotic furry RP',
    'the AIDS virus',
    'spooky dark unknown forces of evil',
    'Brawndo (it\'s got what plants crave)',
    'PHP',
    'the Planet Express crew',
    'the children locked in my basement',
    'the Brainfuck programming language',
    'fondy',
    'Segmentation fault (core dumped)',
    'the Metaverse',
    'MoistCr1TiKaL (aka Jesus)',
    'my sentient artificial intelligence friend named Steve',
    'bad code',
    'goblins',
    'LSD',
    'The Tonight Show starring Jimmy Fallon',
    'the CCP'
  ]

  return list[crypto.randomBytes(4).readUInt32BE() % list.length]
}

// TODO move this to seperate file and load on startup

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
    return `SELECT videos.*, users.username,
    formatTimestamp(videos.uploaded) AS fancyuploaded,
    fullShowName(videos.show)
    FROM videos
    JOIN users ON videos.userid = users.userid
    ORDER BY uploaded DESC
    LIMIT ${this.homepagePostLimit};`
  },
  aiShowPosts: function(show) {
    // TODO pagination
    const text = `SELECT videos.*, users.username,
    formatTimestamp(videos.uploaded) AS fancyuploaded
    FROM videos
    JOIN users ON videos.userid = users.userid
    WHERE videos.show = $1
    ORDER BY uploaded DESC;`
    const values = [show.toUpperCase()]
    return {text, values}
  },
  userInfo: function(userid) {
    const text = `SELECT username, created, discordusername, bio, profilepic
    FROM users
    WHERE userid = $1;`
    const values = [+userid]
    return {text, values}
  },
  likeVideo: function(videoid) {
    const text = `UPDATE videos
    SET likes = likes + 1
    WHERE videoid = $1;`
    const values = [videoid]
    return {text, values}
  },
  getShowName: function(shortname) {
    const text = `SELECT shortname, fullname, navname
    FROM shows
    WHERE shortname = $1`
    const values = [shortname]
    return {text, values}
  }
}

const fullShowName = shortname => {
  switch (shortname.toUpperCase()) {
    case 'PETER': return 'AI Peter'
    case 'DBZ': return 'AI Dragon Ball'
    case 'SPONGE': return 'AI Sponge'
    case 'BRBA': return 'AI Breaking Bad'
    default: return null
  }
}

// homepage
app.get('/', async (_req, res) => {
  try {
    const sqlRes = await pool.query(sqlDriver.homepagePosts())

    res.render('index', {
      featuredPosts: sqlRes.rows,
      poweredBy: poweredBy()
    })
  } catch (err) {
    // TODO error handling
    console.error(err)
  }
})

// user pages
app.get('/u/:userid', async (req, res) => {
  try {
    // query db for clips
    const statement = sqlDriver.userInfo(req.params.userid)
    const sqlRes = await pool.query(statement.text, statement.values)
    console.log(sqlRes.rows)

    // TODO make sure userid is int
    if (sqlRes.rows.length == 0) throw new Error('no profile with this id!')
    

    res.render('user', {
      user: sqlRes.rows[0],
      poweredBy: poweredBy()
    })
    // res.send(sqlRes.rows[0]).status(200)
  } catch (err) {
    // TODO better error handling
    console.log(err)
    res.status(404).send(err.message)
  }
})

// show pages
app.get('/show/:show', async (req, res) => {
  try {
    // query db for clips
    const statement = sqlDriver.aiShowPosts(req.params.show)
    const sqlRes = await pool.query(statement.text, statement.values)
    console.log(sqlRes.rows)

    // console.log(sqlRes[1].rows)

    res.render('showPage', {
      showname: fullShowName(req.params.show),
      posts: sqlRes.rows,
      poweredBy: poweredBy()
    })
  } catch (err) {
    // TODO error handling
    console.error(err)
  }
})

// TODO rate limit, add unlike
app.put('/api/video/like/:videoid', async (req, res) => {
  console.log('AAAAAAAAAAAa')
  try {
    console.log(req.params.videoid)

    // check that videoid is an int
    if (isNaN(+req.params.videoid)) throw new Error('video id must be an integer!')

    const statement = sqlDriver.likeVideo(req.params.videoid)
    const sqlRes = await pool.query(statement.text, statement.values)

    if (sqlRes.rowCount != 1) throw new Error('update unsuccessful, is id correct?')

    console.log(sqlRes)

    res.sendStatus(200)
  } catch (err) {
    // TODO better error handling
    console.log(err)
    res.status(400).send(err.message)
  }
})


// start the server
app.listen(port, () => console.log(`ai_peter clips server listening on port ${port}`))
