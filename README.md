**Pastebin scraper in Ruby**
This is based off the old scraping API available to a 'lifetime' Pastebin member.
Description of functions:
1. Each minute, pull the 100 most recent pastes from Pastebin.
2. Using Redis as a cache, check each of these 100 keys and see if they have already been added to the database.
    - Each key is checked if it exists in Redis.
    - If it does, move to the next key (no need to request paste)
    - If it does not, create a key in Redis for that Pastebin key.  Also request the paste.
    - Set the above key to expire in 10 minutes.
 3. Insert all new entries into MongoDB.
 
 - This was set up to run as a cron job every minute, also pointing to .bash_profile where the MongoDB environment variables (user and password) are stored:
 ```
 * * * * * $HOME/.bash_profile; /path/to/pb_controller.rb >> /path/to/logfile 2>&1 
 ```
 
 
 - The 'Mongo' and 'Redis' gems need to be installed to run:
 ``` 
gem install redis
gem install mongo
```

- Update the config.yml file to set the Redis and MongoDB info.

In this case Redis is used locally (and only exposed locally) so no authentication was put into place for Redis.
