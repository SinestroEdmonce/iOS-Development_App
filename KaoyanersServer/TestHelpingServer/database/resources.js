mongoose = require('mongoose');

var recourses_schema = new mongoose.Schema({
    id: String,
    catalog:String,
    name:String,
    owner_id:String,
    file_tag:String,
    introduction:String,
    url:String,
    suffix:String
  });


module.exports = mongoose.model("resources", recourses_schema);