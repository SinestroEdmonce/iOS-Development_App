mongoose = require('mongoose');

var articles_schema = new mongoose.Schema({
    id:String,
    name: String,
    circle:String,
    owner_id:String,
    content:String,
    like:Number,
    comment_id_list:[],
    img_url_list:[]
  });

module.exports = mongoose.model("articles", articles_schema);