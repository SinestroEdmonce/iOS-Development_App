mongoose = require('mongoose');

var comments_schema = new mongoose.Schema({
    id:String,
    owner_id:String,
    content:String,
    like:Number,
    comment_id_list:[]
  });

module.exports = mongoose.model("comments", comments_schema);