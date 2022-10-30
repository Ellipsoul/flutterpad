const express = require("express")
const mongoose = require("mongoose")
const cors = require("cors")
const authRouter = require("./routes/auth")
const documentRouter = require("./routes/document")
const http = require("http")

// Default to port 3001 when developing locally
// eslint-disable-next-line no-undef
const PORT = process.env.PORT | 3001
const DB =
  "mongodb+srv://flutterpad:hHdY2467kn0qkyYE@cluster0.m793c4c.mongodb.net/?retryWrites=true&w=majority"

const app = express() // Initialise express app

let server = http.createServer(app) // Create an HTTP server from the express app
let io = require("socket.io")(server)

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

io.on("connection", (socket) => {
  console.log("Connected on " + socket.id)
  // Join a room once a socket has connected
  socket.on("join", (documentId) => {
    socket.join(documentId)
  })

  // Broadcast to connected clients when typing is observed
  socket.on("typing", (data) => {
    socket.broadcast.to(data.room).emit("changes", data)
  })
})

// Run the express app
server.listen(PORT, "0.0.0.0", () => {
  console.log(`Connected at port ${PORT}`)
})
