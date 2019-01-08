var express = require('express');
var articles=require('../database/article');
var router = express.Router();

/* GET articles listing. */
router.get('/', function(req, res, next) {
    articles.find({},function(err,doc){
        if(err) res.status(500).send({error:'something blew up'});
		else if(!doc) res.status(500).send('data doesnot exist');	
		else 
		{
			if(doc.length>=1)
			{
				res.status(200).send(doc);
				console.log(doc);
			}
			else
			{
				res.status(200).send('');
				console.log(doc.length);
			}
		}
    });
});

module.exports = router;



