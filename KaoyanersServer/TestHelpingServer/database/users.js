mongoose = require('mongoose');

var users_schema = new mongoose.Schema({
    id: String,
    self_article_id_list:[],
    favorate_article_id_list:[],
    favorate_circle_id_list:[],
    password: String,
  //additional attribution
    self_resources_id_list:[],
    img_url:String
  });


module.exports = mongoose.model("users", users_schema);