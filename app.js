/*
    SETUP
*/
// Express
const { create } = require('domain');
var express = require('express');   // We are using the express library for the web server
var app     = express();            // We need to instantiate an express object to interact with the server in our code
PORT        = 9999;                 // Set a port number at the top so it's easy to change in the future

// Database
var db = require('./db-connector');

// Handlebars    
const { engine } = require('express-handlebars');
var exphbs = require('express-handlebars');     // Import express-handlebars
app.engine('.hbs', engine({extname: ".hbs"}));  // Create an instance of the handlebars engine to process templates
app.set('view engine', '.hbs'); 

/*
    ROUTES
*/
app.get('/', function(req, res)
    {
        res.send("the server is running");
    });

/*
LISTENER
*/
app.listen(PORT, function(){            // This is the basic syntax for what is called the 'listener' which receives incoming requests on the specified PORT.
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.')
});