const express = require("express")
const User = require("../models/user")
const auth = require("../middleware/auth")
const jwt = require("jsonwebtoken")
const bodyParser = require("body-parser")

const jsonParser = bodyParser.json() // New JSON parser
const authRouter = express.Router()

// Request to post new user data to MongoDB
authRouter.post("/api/signup", jsonParser, async (req, res) => {
  try {
    console.log(req.body)
    const { name, email, profilePicture } = req.body
    let user = await User.findOne({ email })
    // Create a new user if one does not already exist
    if (!user) {
      user = new User({
        name,
        email,
        profilePicture,
      })
      user = await user.save() // Inserts the user document into the database
    }
    // Sign the JWT with the unique user id
    const token = jwt.sign({ id: user._id }, "passwordKey")

    res.json({ user, token }) // Sets the response in json format
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
})

// Request to get a user's data
authRouter.get("/", auth, async (req, res) => {
  const user = await User.findById(req.user)
  res.json({ user, token: req.token })
})

module.exports = authRouter
