# App-Server_introduction
## Environment, Tools and Frameworks
- Ubuntu Linux
- Node.js
- Express
- Mongodb(database)

## Get started
- Install Node.js 

   you can get the Node.js from internet and you need to install npm in the meantime.(npm usually would be installed by default while you are installing Node.js)
    
- Install Mongodb

  you can get the Mongodb from the official website .
  
- Run and set up the Database

  you need to run the mongodb you just installed and set up a database named *TestHelpingServer*
  
- start the project

  Get into the directory of project and run in the command line
  ```
  npm start
  ```
  you would see *"connection successful"* if everything goes well.

## Main databases and Main Requests processing
- Databases
    - users
    - resources
    - comments
    - circles
    - atricles

users is used to processing everything related to user. Check out the code if you need more details about the services it provided.

- Main Post Requests
    - https:address:3000/users/resources
    - https:address:3000/users/post_article
    - https:address:3000/users/upload_img

The three requests above is the most important part of this server.

*resources* let user upload resources and it would update `users` and `resources` database

*post_article* let user uploat article and it would update `users`, `articles` and `circles` database. After this, if your passage has images to upload, you need to upload it right after article uploading using the third request *upload_img*.

check out the code when you need more details.