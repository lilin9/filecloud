sudo docker stop sqlserver
sudo docker stop nginx 
sudo docker stop filecloud_web_container
sudo docker stop filecloud_api_container


sudo docker rm sqlserver
sudo docker rm nginx
sudo docker rm filecloud_web_container
sudo docker rm filecloud_api_container

sudo docker rmi filecloud_nginx
sudo docker rmi filecloud_api
sudo docker rmi filecloud_web
sudo docker rmi mcr.microsoft.com/mssql/server
