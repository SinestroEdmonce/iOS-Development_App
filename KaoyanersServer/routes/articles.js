var express = require('express');
var articles=require('../database/article');
var router = express.Router();

/* GET articles listing. */
router.get('/', function(req, res, next) {
	var num=req.query.number

    articles.find({},function(err,doc){
        if(err) res.status(500).send({error:'something blew up'});
		else if(!doc) res.status(500).send('data doesnot exist');	
		else 
		{	
			doc.reverse()
			res.send({result:'isSuccess',value:doc})
		}
    });
});

router.get('/by_id', function(req, res, next) {
	var aid=req.query.id;

    
    articles.find({id:aid},function(err,doc){
        if(err) res.send({error:'something blew up'});
		else if(!doc) res.send({info:'data does not exist'});	
		else 
		{
				res.send({result:'isSuccess', value:{text:doc[0].content,img_url:doc[0].img_url_list}});
		}
    });
});

module.exports = router;



