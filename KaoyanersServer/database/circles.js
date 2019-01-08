mongoose = require('mongoose');

var circles_schema = new mongoose.Schema({
    name: String,
    article_id_list:[]
  });


module.exports = mongoose.model("circles", circles_schema);