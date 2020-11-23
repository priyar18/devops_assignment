# devops-takehome-challenge
devops-takehome-challenge

You can find terraform state uploaded in s3

Once the infra is ready, I have used Ansible as configuration management

Here is the deployment strategy
* install docker
* git clone project
* deploy mysql application on container using docker
* deplo node application on container using docker
* hit loadbalancer:4000 in browser

I have initialised ansible role as nodejs
deploy.yml ---> mysql(role) ---> tasks ---> main.yml

deploy.yml
consists of ansible playbook start where I have stated ubuntu user will run the play and enabled escalation privilege. Then it is calling to mysql role

mysql role have multiple folder structure created as we initialise role
README.md  defaults  files  handlers  meta  tasks  templates  tests  vars

- inside task main.yml file I have called different yml
* first is docker.yml. In this yml docker installation steps are given
* second is git.yml. in this yml git clone to local is happening
* third is sql-app.yml. in this yml how image mysql image is built by dockerfile and container is launch steps are given
* fourth is node-app.yml in this yml how image node image is built by dockerfile and container is launch and linked with mysql steps are given

Testing our complete app
* Get homepage of your app curl -X GET localhost:4000
* Get list of all students from test database curl -X POST 192.168.43.147:4000/get-students Here 192.168.43.147 is my host IpAddress ifconfig | grep inet
* Add a new student to your test db curl --header "Content-Type: application/json" -d '{"rollNo": 1130360, "name": "Abhishek Goswami"}' -X POST localhost:4000/add-student
* Again fetch all students to see updated results curl -X POST 192.168.43.147:4000/get-students
* Modify source code of nodejs app, build image, run container and test again.

For High Availabilty I have launched 2 instances in different zones so that if one zone goes down other will server the request. This is being done by terraform.

How the request will be served:
* request will come through loadbalancer
* it will be routed to respective tg
* from tg request will be served to any instances by Round Robin method
* request will be going to 4000 port of node and from that node it is linked to node container application port 4000
* mysql container mapped host port 6603 with container port 3306
