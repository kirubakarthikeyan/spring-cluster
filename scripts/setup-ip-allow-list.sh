POD_ORDINAL_START=${1:-0}
POD_ORDINAL_END=${1:-1}
for i in $(seq ${POD_ORDINAL_START} ${POD_ORDINAL_END}); do
  echo "Configuring pod mysql-cluster/mysql-cluster-${i}"
  cat <<'  EOF' | kubectl exec -i mysql-cluster-${i} -- bash -c 'mysql -uroot -proot --password=${MYSQL_ROOT_PASSWORD}'
INSTALL PLUGIN group_replication SONAME 'group_replication.so';
RESET PERSIST IF EXISTS group_replication_ip_allowlist;
RESET PERSIST IF EXISTS binlog_transaction_dependency_tracking;
SET @@PERSIST.group_replication_ip_allowlist = 'mysql-headless-service.default.svc.cluster.local';
SET @@PERSIST.binlog_transaction_dependency_tracking = 'WRITESET';
  EOF
done
