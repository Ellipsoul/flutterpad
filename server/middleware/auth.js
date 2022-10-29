const jwt = require("jsonwebtoken")

const auth = async (req, res, next) => {
  try {
    // Get the authentication token from the header
    const token = req.header("x-auth-token")
    // User is not authenticated
    if (!token) {
      return res.status(401).json({ msg: "Access Denied" })
    }
    // Attempt to verify the authentication token and append to request
    const verified = jwt.verify(token, "passwordKey")
    if (!verified) {
      return res.status(401).json({ msg: "Token verification failed" })
    }
    req.user = verified.id
    req.token = token

    next()
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}

module.exports = auth
