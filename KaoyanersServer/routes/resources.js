var express = require('express');

//resources
var resources=require('../database/resources');
var router = express.Router();



/* GET resources listing. */
router.get('/', function(req, res, next) {
    var pcat=req.query.catalog;

    
    resources.find({catalog:pcat},function(err,doc){
        if(err) res.send({error:'something blew up'});
		else if(!doc) res.send({info:'data does not exist'});	
		else 
		{
			if(doc.length>=1){
                doc.reverse()
                res.send({result:'isSuccess',value:doc});
            }
			else
                res.status(500).send();
		}
    });
});

/*download by id */
router.get('/download',function(req,res,next){
    var did=req.query.id;

    console.log(did);
    
    resources.find({id:did},function(err,doc){
        if(err) res.send({error:'something blew up'})
        else if(!doc) res.send({info:'data does not exist'})
        else{
            //console.log(doc[0].id);
            //console.log(doc[0].name);

            res.download(doc[0].url,doc[0].name);
        }
    })

})

module.exports = router;
