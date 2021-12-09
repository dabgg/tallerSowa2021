const mongoose = require('mongoose')
const Schema = mongoose.Schema

const newSchema = new Schema({
    nickname:String,
    password:String
})

module.exports = mongoose.model('User',newSchema)