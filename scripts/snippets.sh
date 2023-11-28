# instance - 0
kubectl exec -it mysql-cluster-0 -- \
    /bin/bash \
    -c 'mysqlsh --uri="root:$MYSQL_ROOT_PASSWORD@mysql-cluster-0.mysql-headless-service.default.svc.cluster.local"'


# instance - 1
kubectl exec -it mysql-cluster-1 -- \
    /bin/bash \
    -c 'mysqlsh --uri="root:$MYSQL_ROOT_PASSWORD@mysql-cluster-1.mysql-headless-service.default.svc.cluster.local"'


# configure instance

\js
dba.configureInstance('root@mysql-cluster-0.mysql-headless-service.default.svc.cluster.local', {password: os.getenv("MYSQL_ROOT_PASSWORD")});
dba.configureInstance('root@mysql-cluster-1.mysql-headless-service.default.svc.cluster.local', {password: os.getenv("MYSQL_ROOT_PASSWORD")});


# check instance config

dba.checkInstanceConfiguration()

# cluster 
cluster = dba.createCluster("spring")

# login to instance 0 and add instance 1 
cluster.addInstance('root@mysql-cluster-1.mysql-headless-service', {password: os.getenv("MYSQL_ROOT_PASSWORD"), recoveryMethod: 'clone'});


# create sample database and records in instance 0 to test replication
\sql
create database loanapplication;
use loanapplication
CREATE TABLE loan (loan_id INT unsigned AUTO_INCREMENT PRIMARY KEY, firstname VARCHAR(30) NOT NULL, lastname VARCHAR(30) NOT NULL , status VARCHAR(30) );

INSERT INTO loan (firstname, lastname, status) VALUES ( 'Fred','Flintstone','pending');
INSERT INTO loan (firstname, lastname, status) VALUES ( 'Betty','Rubble','approved');

SELECT * FROM loan;


# verify if the records are present in instance 1 
show databases;
use loanapplication;
SELECT * FROM loan;
