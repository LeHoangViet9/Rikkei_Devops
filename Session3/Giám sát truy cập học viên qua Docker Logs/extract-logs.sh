
ubuntu@ip-172-31-17-125:~$ sudo docker logs -t --tail 15 rikkei-course-service
2026-09-18T02:26:12.497947126Z /docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
2026-09-18T02:26:12.499470458Z 10-listen-on-ipv6-by-default.sh: info: /etc/nginx/conf.d/default.conf is not a file or does not exist
2026-09-18T02:26:12.499839286Z /docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
2026-09-18T02:26:12.499994799Z /docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
2026-09-18T02:26:12.502992924Z /docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
2026-09-18T02:26:12.504628707Z /docker-entrypoint.sh: Configuration complete; ready for start up
2026-09-18T02:26:12.515595707Z 2026/09/18 02:26:12 [notice] 1#1: using the "epoll" event method
2026-09-18T02:26:12.515804658Z 2026/09/18 02:26:12 [notice] 1#1: nginx/1.29.1
2026-09-18T02:26:12.516723693Z 2026/09/18 02:26:12 [notice] 1#1: built by gcc 14.2.0 (Alpine 14.2.0) 
2026-09-18T02:26:12.516737501Z 2026/09/18 02:26:12 [notice] 1#1: OS: Linux 7.0.0-1006-aws
2026-09-18T02:26:12.517245515Z 2026/09/18 02:26:12 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1024:524288
2026-09-18T02:26:12.517255226Z 2026/09/18 02:26:12 [notice] 1#1: start worker processes
2026-09-18T02:26:12.517258709Z 2026/09/18 02:26:12 [notice] 1#1: start worker process 20
2026-09-18T02:26:12.517261947Z 2026/09/18 02:26:12 [notice] 1#1: start worker process 21
2026-09-18T02:26:46.790856915Z 172.17.0.1 - - [18/Sep/2026:02:26:46 +0000] "GET / HTTP/1.1" 200 12127 "-" "curl/8.18.0" "-"
ubuntu@ip-172-31-17-125:~$ 