Docker.com scripts for TEMENOS Design Studio for T24 Continous Integration (CI) "DevOps" demo environment.

## How to build

    build.sh
    docker run -d -p 8080:8080 -p 3690:3690 -p 9001:9001 -p 2222:2222 -p 9089:9089 -p 10999:10999 -p 8787:8787 dsdemo
    ...
    docker stop ...
    docker ps -a
    ...
    docker start ...
    
You typically want to run "docker run" once, and then "start" it N times.  
(Each "docker run" will create _another_ Container of the same Image.)

## Available services
* Subversion: svn://developer1@localhost, password "developer1" (uses TCP/IP port 3690)
* Jenkins: http://localhost:8080
* T24 Browser: http://localhost:9089/BrowserWeb/ (SSOUSER1 / 123456)
* CLI Login: ssh -p 2222 root@localhost, login with password "demo"
  * T24 Classic: tRun -cf tafj EX
  * T24 TAFj scripts, e.g. DBTools
* Supervisor: http://localhost:9001
* Java Remote Debugging: port 8787

## PS

Caveat emptor: The documentation and scripts in this Git repository are provided "as is",
just a how-to example, and not an officially supported "product" by 
TEMENOS The Banking Software Company.  See [LICENSE.txt](LICENSE.txt)

Originally started by Michael Vorburger on April 29th, 2015.
* http://blog2.vorburger.ch/2015/05/docker-based-virtual-machine-for-demos.html
* https://www.youtube.com/watch?v=wdWll0vpE1U

Contributions via open source pull requests most welcome.
