## Initialize and connect to database
Firstly, create a default cluster
```
pg_createcluster -u postgres -p 5432 --start 13 main
```

Initialize msf database and you will get a config file at `/var/lib/postgresql/.msf4/db/database.yml`
```
msfdb -p 5432 --user msf --pass msf --msf-db-name msf init
```


Launch msfconsole and execute:
```
db_connect -y /var/lib/postgresql/.msf4/db/database.yml
db_status
```