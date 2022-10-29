const express = require("express")
const auth = require("../middleware/auth")
const Document = require("../models/document")
const documentRouter = express.Router()

// Route to create a new document
documentRouter.post("/doc/create", auth, async (req, res) => {
  try {
    const { createdAt } = req.body
    let document = new Document({
      uid: req.user,
      createdAt,
      title: "Untitled Document",
    })

    document = await document.save()
    res.json(document)
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
})

// Route to list all documents created by a user
documentRouter.get("/docs/me", auth, async (req, res) => {
  try {
    let documents = await Document.find({ uid: req.user })
    res.json(documents)
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
})

module.exports = documentRouter
