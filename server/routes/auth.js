const express = require("express")
const User = require("../models/user")
var bodyParser = require("body-parser")

var jsonParser = bodyParser.json() // New JSON parser
const authRouter = express.Router()

authRouter.post("/api/signup", jsonParser, async (req, res) => {
  try {
    console.log(req.body)
    const { name, email, profilePicture } = req.body
    let user = await User.findOne({ email: email })
    // Create a new user if one does not already exist
    if (!user) {
      user = new User({
        name,
        email,
        profilePicture,
      })
      user = await user.save() // Inserts the user document into the database
    }
    res.json({ user }) // Sets the response in json format
  } catch (err) {
    console.log(err)
  }
})

module.exports = authRouter
