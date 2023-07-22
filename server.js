const path = require('node:path')

// set express stuffs tbh
const express = require('express')
const app = express()
const port = 3420
app.set('view engine', 'pug')
app.use('/public', express.static(path.join(__dirname, 'public')))

let sqlDriver = {
  postLimit: 10,
  homepagePostLimit: 6,
  homepagePosts: function() {
    console.log('this will get homepage posts')
    return `SELECT *
    FROM videos
    ORDER BY uploaded DESC
    LIMIT ${this.homepagePostLimit};`
  },
  // user pages, accepts both username and userid (for permalink)
  userPage: function(userid) {
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


app.get('/', (req, res) => {
  console.log(sqlDriver.userPage('bingus123'))
  console.log(sqlDriver.userPage('123'))
  res.render('index', { title: 'wabangus tbh' })
})

// launch the server
app.listen(port, () => console.log(`ai_peter clips server listening on port ${port}`))
