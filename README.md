# Fender Digital Platform Engineering Challenge

## Description

I implemented this in RoR using JWT because of the gem support.  Because JWT are "self contained" (store expiration in the token) in order to enforce logout, I chose to store the token in the db so that once a user logs out, that token could be "expired" server side.  Therefore to login, the server checks the token against the token in the db for that user to make sure they haven't logged out, in addition to verifying the token itself is valid and not expired.  Also, due to the implementation I used, the User model has a password_digest field instead of password.  It would be trivial to add a field called "password" if required.

## Setup

1. requires ruby >= 2.3.0
2. run 'bundle install'
3. requires postgres to be running locally
4. run 'rake db:create'
5. run 'rake db:migrate'
6. run 'rails s'
7. run 'rake test' to run tests

## Enhancements

1. token refresh function
2. different access permissions for different users (admin, etc.)
3. ability to have multiple tokens per user (for multiple devices)