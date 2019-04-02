# Docker
## Docker Project for Weather Forecast Application  

### Launch EC2 AWS Instance  
* Sign in to your AWS Account.  
* Follow the User guide documentation to launch Amazon EC2 Linux Instance.  
  [https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html#ec2-launch-instance]  
* Once your instance is in running state, check if the status checks are passed. Then, connect to your instance using putty.  
[https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html]  
* Set up WinSCP to transfer files to your Linux instance. Steps are provided in the above link.  

### Docker Installation in AWS Instance    
* Update the installed packages and package cache on your instance.  
	`sudo yum update -y`  
* Install Docker.  
	`sudo yum install -y docker`  
* Start the Docker service.  
	`sudo service docker start`  
*  Add ec2-user to docker group for accessing docker as root(without using sudo).  
	`sudo usermod -a -G docker ec2-user`  

### Sign up for Docker Hub  
* Register at https://hub.docker.com/  
* Login to docker with the Docker Hub Account  
	`docker login -u username`  

### Download and run a base image
* Search for a base docker in Docker Hub with 'python flask'  
* Pull the suitable image  
	`docker pull tiangolo/uwsgi-nginx-flask`  
* Run the Docker Container with the downloaded image  
	`docker run -p 80:80 tiangolo/uwsgi-nginx-flask`  
* Run the container with a user friendly name and in background  
	`docker run -d --name "Base_Docker" -p 80:80 tiangolo/uwsgi-nginx-flask`  
* Check the browser if the site is up and running.  
* Use ctrl -c to shutdown the container.  

### Git project to EC2 AWS  
* Create a folder at your convenient location and clone the repository.  
* Once connected to instance via WinSCP, transfer DockerProject to /home/ec2-user/  
* This copies 'docker' folder and 'dockerfile' into /home/ec2-user/DockerProject. Check the directory structure:   
  DockerProject  
&nbsp;&nbsp;├── docker  
&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── HTML  
&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── index.html&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; # Home Page  
&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── static&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; # Static template folder  
&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── CSS  
&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── styles.css&nbsp; # CSS styling for HTML page  
&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── myScript.js&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; # Javascript   
&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── app.py&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; # Dynamic Content for Flask App  
&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── dailyweather.csv&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# Sample data of application  
&nbsp;&nbsp;└── Dockerfile    
  
### Create Docker Image for your Weather application using the base docker image downloaded.  
* Dockerfile should be configured accordingly to generate your own image.  
  FROM tiangolo/uwsgi-nginx-flask:python3.7  
  COPY ./docker /app  
  CMD ["python", "app.py"]  
* Set the current directory to /home/ec2-user/DockerProject in EC2 Console opened via putty.  
  `cd /home/ec2-user/DockerProject`  
* Build docker image  
  `docker build -t weatherapp .`  
* Running new image  
  `docker run -d --name my_weatherapp -p 80:80 weatherapp`  
* Now, the Docker container starts serving your application at port 80.  

### Push created image to repository  
* Check all the docker processes running.  
	`docker ps`  
* Copy the ContainerID of the desired docker process. We can identify the process by its image name(In our case, it is 'weatherapp')  
	`docker commit <Container ID> <username>/<repository:tag>`  
* Push after logging in to Dockerhub.  
	`docker push <username>/<repository:tag>`  
	
### Save Docker Container Image to archive  
* Save docker image.  
	`docker save <image> > <out>.tar`  
	`docker save <image id> | gzip > <out>.tar.gz`  
	
### Load archive/ Pull image then run it  
* Load the image archived.  
	`docker load -i out.tar.gz`  
	`Loaded image: <repository>:<tag>`  
	
	or pull the image from Dockerhub.  
	`docker pull <repository>:<tag>`  
* Run the loaded image.  
	`docker run -d -p 80:80 <repository>:<tag>`
