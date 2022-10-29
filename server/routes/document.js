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

// Route to update a document title
documentRouter.post("/doc/title", auth, async (req, res) => {
  try {
    const { id, title } = req.body
    const document = await Document.findByIdAndUpdate(id, { title })
    res.json(document)
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
})

// Route to find a document by its ID
documentRouter.get("/doc/:id", auth, async (req, res) => {
  try {
    const document = await Document.findById(req.params.id)
    res.json(document)
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

module.exports = documentRouter
