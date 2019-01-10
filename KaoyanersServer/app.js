var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var mutipart= require('connect-multiparty');


//connectiong database
var mongoose=require('mongoose');
mongoose.connect('mongodb://localhost/KaoyanersServer',
{ useNewUrlParser: true },function(err) {
  if (err) {
    console.log('connection error', err);
  } else {
    console.log('connection successful');
  }
});



//router defination
var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var resourcesRouter = require('./routes/resources');
var circlesRouter=require('./routes/circles');
var articlesRouter=require('./routes/articles')

//upload file directory
var app = express();

app.use(mutipart({uploadDir:'./files'}));

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
//file uploading middleware
//app.use(mutipart({uploadDir:'./file'}));



//route
app.use('/', indexRouter);
app.use('/users', usersRouter);
app.use('/resources',resourcesRouter);
app.use('/circles',circlesRouter);
app.use('/articles',articlesRouter);


// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
