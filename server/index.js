const express = require("express")
const mongoose = require("mongoose")
const cors = require("cors")
const authRouter = require("./routes/auth")
const documentRouter = require("./routes/document")

// Default to port 3001 when developing locally
// eslint-disable-next-line no-undef
const PORT = process.env.PORT | 3001
const DB =
  "mongodb+srv://flutterpad:hHdY2467kn0qkyYE@cluster0.m793c4c.mongodb.net/?retryWrites=true&w=majority"

const app = express() // Initialise express app

app.use(cors()) // Initialise necessary CORS policy
app.use(express.json())
app.use(authRouter)
app.use(documentRouter)

// Connect to MongoDB
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connected to MongoDB")
  })
  .catch((err) => {
    console.log(err)
  })

// Run the express app
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Connected at port ${PORT}`)
})
