# miscellaneous mysql stuff

## list users 
```
select host, user from mysql.user;
```

## create user
```
CREATE USER 'some_user'@'localhost'
  IDENTIFIED WITH sha256_password BY 'some_password'
  PASSWORD EXPIRE INTERVAL 180 DAY;
```
