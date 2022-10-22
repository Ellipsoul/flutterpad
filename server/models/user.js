const mongoose = require("mongoose")

// Define user schemea in MongoDB
const userSchema = mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
  },
  profilePicture: {
    type: String,
    required: true,
  },
})

// Define database model for User object
const User = mongoose.model("User", userSchema)

module.exports = User
