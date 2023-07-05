const path = require('node:path')

// set express stuffs tbh
const express = require('express')
const app = express()
const port = 3420
app.set('view engine', 'pug')
app.use('/public', express.static(path.join(__dirname, 'public')))


app.get('/', (req, res) => {
  res.render('index', { title: 'wabangus tbh' })
})

// launch the server
app.listen(port, () => console.log(`ai_peter clips server listening on port ${port}`))
