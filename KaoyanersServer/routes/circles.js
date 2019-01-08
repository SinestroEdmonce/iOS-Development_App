var express = require('express');
var router = express.Router();
var circles=require('../database/circles');

router.get('/', function(req, res, next) {
  
    circles.find({}, function(err, docs){
      if (err) {
              console.log('出错'+ err);
              return;
      }
      res.json({data:docs});
    }) 
  });

router.post('/',function(req,res,next){
    circles.create({                             
        name: req.body.name
    },function(err,doc){ 
        if (err) {
                res.status(500).send(err);
            } else {
                res.status(200).send('suc');
            }
        });

})

  module.exports = router;