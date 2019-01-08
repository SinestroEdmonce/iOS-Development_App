var express = require('express');
var router = express.Router();
var users=require('../database/users');
var articles=require('../database/article')
var circles=require('../database/circles')
var comments=require('../database/comments')
var resources=require('../database/resources')

//for uploading file
var mutipart=require('connect-multiparty');
var mutipartMIDDEWARE=mutipart();

router.get('/', function(req, res, next) {
  var uid=req.query.id;

  users.find({id: uid}, function(err, docs){
    if (err) {
            console.log('出错'+ err);
            return;
    }
    res.json({data:docs});
  }) 
});

router.post('/login',function(req,res){
	
	var uid=req.body.id;	
	
	users.findOne({id:uid},function(err,doc){
		if(err)
		{
			res.status(500).send({error:'something blew up'});
		}
		
		else if(!doc)
		{
			
			res.status(404).send('cannot find user');
		}
		else
		{
			if(req.body.password!=doc.password)
				res.status(500).send({error:'wrong password'});
			else
				res.status(200).send();
		}
	})
	
});


router.post('/upload_head',mutipartMIDDEWARE,function(req,res){

  //attribution 
  var uid=req.body.id;
  var hurl='./'+req.files.files.path;

  //update users database
  whereStr={id:uid};
  updateStr={img_url:hurl};

  users.updateOne(whereStr,updateStr,function(err, docs){
    if (err) {
            res.status(500).send();
            return
    }
    res.json({statu: 200});
  })

})

router.post('/register',function(req,res){
        
  var uid=req.body.id;
  var upw=req.body.password;
  console.log(upw)


  users.findOne({id: uid},function(err,doc){   
    if(err){ 
        res.status(500).send({error:'something blew up'});
    }else if(doc){ 
        res.status(500).send('user exists');
    }else{ 
        users.create({                             
            id: uid,
            password: upw,
        },function(err,doc){ 
            if (err) {
                    res.status(500).send(err);
                } else {
                    res.status(200).send('suc');
                }
              });
    }
  });
});


router.post('/post_article',function(req,res){
  
  var uid=req.body.id;
  var article_id=req.body.article_id;

  //update article database
  articles.create({                             
    owner_id: uid,
    id: article_id,
    name:req.body.name,
    circle:req.body.circle,
    like:0,
    content:req.body.content
  },function(err,doc){ 
    if (err) {
      res.status(500).send();
      return
}
  });

  //update circles database
  var whereStr={name:req.body.circle};
  var updateStr={$push : { article_id_list: article_id}};
  
  circles.updateOne(whereStr,updateStr,function(err, docs){
    if (err) {
            res.status(500).send();
            return
    }
  });
        

  //update users database
  whereStr={id:uid};
  updateStr={$push : { self_article_id_list: article_id}};

  users.updateOne(whereStr,updateStr,function(err, docs){
    if (err) {
            res.status(500).send();
            return
    }
    res.json({statu: 200});
  })

});

router.post('/favorate_article',function(req,res){
        
  var uid=req.body.id;
  var article_id=req.body.article_id;

  var whereStr={id:uid};
  var updateStr={$push : { favorate_article_id_list: article_id}};

  users.updateOne(whereStr,updateStr,function(err, docs){
    if (err) {
            res.status(500).send();
            return
    }
    res.json({statu: 200});
  })
  
});

router.post('/unfavorate_article',function(req,res){
        
  var uid=req.body.id;
  var article_id=req.body.article_id;

  var whereStr={id:uid};
  var updateStr={$pull : { favorate_article_id_list: article_id}};

  users.updateOne(whereStr,updateStr,function(err, docs){
    if (err) {
            res.status(500).send();
            return
    }
    res.json({statu: 200});
  })
  
});


router.post('/favorate_circle',function(req,res){
        
  var uid=req.body.id;
  var circle_id=req.body.circle_id;

  var whereStr={id:uid};
  var updateStr={$push : { favorate_circle_id_list: circle_id}};

  users.updateOne(whereStr,updateStr,function(err, docs){
    if (err) {
            res.status(500).send();
            return
    }
    res.json({statu: 200});
  })
  
});

router.post('/unfavorate_circle',function(req,res){
        
  var uid=req.body.id;
  var circle_id=req.body.circle_id;

  var whereStr={id:uid};
  var updateStr={$pull : { favorate_circle_id_list: circle_id}};

  users.updateOne(whereStr,updateStr,function(err, docs){
    if (err) {
            res.status(500).send();
            return
    }
    res.json({statu: 200});
  })
  
});


router.post('/comment',function(req,res){
  
  var uid=req.body.id;
  var comment_id=req.body.comment_id;


  //update comment database
  comments.create({                             
    owner_id: uid,
    id: comment_id,
    like:0,
    content:req.body.content
  },function(err,doc){ 
    if (err) {
      res.status(500).send();
      return
}
  });
  
});

router.post('/resources',mutipartMIDDEWARE,function(req,res){

  /*update resources database */  
  //attribution 
  var fid=req.body.id;
  var fcatalog=req.body.catalog;
  var fowner=req.body.owner;
  var fname=req.files.files.originalFilename;
  var fintroduction=req.body.introduction;
  var ffile_tag=req.body.file_tag;
  var furl='./'+req.files.files.path;

  var fnamesplit=fname.split('.');
  var fsuffix=fnamesplit[fnamesplit.length-1];

  
  var myobj = {id:fid, catalog:fcatalog, owner_id:fowner, name:fname, introduction:fintroduction, file_tag:ffile_tag, url:furl,suffix:fsuffix };
  resources.create(myobj, function(err, res) {
      if (err) throw err;
      console.log("文档插入成功");
      
  });

  /*update user database */
  whereStr={id:fowner};
  updateStr={$push : { self_resources_id_list: fid}};

  users.updateOne(whereStr,updateStr,function(err, docs){
    if (err) {
            res.status(500).send();
            return
    }
  })

  res.send({result:'isSuccess'});
})

module.exports = router;
