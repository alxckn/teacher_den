servers = %w(sami.chakroun.eu)

role :app, servers
role :web, servers
role :db, servers

server servers[0], primary: true, user: "ubuntu"
