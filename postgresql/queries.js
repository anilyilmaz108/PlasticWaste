const Pool = require('pg').Pool
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'plasticdb',
  password: '176369',
  port: 5432,
})
const getUsers = (request, response) => {
  pool.query('SELECT * FROM shares ORDER BY id ASC', (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

const getUserById = (request, response) => {
  const id = parseInt(request.params.id)

  pool.query('SELECT * FROM shares WHERE id = $1', [id], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

const createUser = (request, response) => {
  const { title, subtitle, datetime, lat, lng, files, typ } = request.body

  pool.query('INSERT INTO shares (title, subtitle, datetime, lat, lng, files, typ) VALUES ($1, $2, $3, $4, $5, $6, $7)', [title, subtitle, datetime, lat, lng, files, typ], (error, results) => {
    if (error) {
      throw error
    }
    response.status(201).send(`User added with ID: ${results.insertId}`)
  })
}

const updateUser = (request, response) => {
  const id = parseInt(request.params.id)
  const { title, subtitle, datetime, lat, lng, files, typ } = request.body

  pool.query(
    'UPDATE shares SET title = $1, subtitle = $2, datetime = $3, lat = $4, lng = $5, files = $6, typ = $7, WHERE id = $8',
    [title, subtitle, datetime, lat, lng, files, typ, id],
    (error, results) => {
      if (error) {
        throw error
      }
      response.status(200).send(`User modified with ID: ${id}`)
    }
  )
}

const deleteUser = (request, response) => {
  const id = parseInt(request.params.id)

  pool.query('DELETE FROM shares WHERE id = $1', [id], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).send(`User deleted with ID: ${id}`)
  })
}

module.exports = {
  getUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
}