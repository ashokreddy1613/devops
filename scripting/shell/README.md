# What is shell scripting?
 Shell scripting is a text file that contains series of commands(called script) that shell(command-line intepreter) can execute that file. 

# why shell scripting in DevOps?

 You know DevOps is all about automation everything- from builds to deployment.
 As a DevOps engineer, there are number of repetitive tasks on daily basis, life of devops engineer would become difficult to do. scripting can help you achieve automation in the SDLC.

## Must know Linus commands as a DevOps & Cloud engineer
 
 ## ls
  -- To check the list of files or folder in the current directory
  
 ## Pwd
  -- It shows your cureent working directory
  
 ## mkdir
  -- To create a new folder 
  
 ## grep
  -- searching text
  
 ## rm -rf "name"
  -- To remove any file or folder 
  
 ## touch "name"
  -- To create a new file 
  
 ## cp "file" "destination"
  -- To copy any file to desired folder 
  
 ## mv "file" "destination"
  -- To move file 
  
# File Management commands

 lets talk about vi- vi is a terminal based editor, you can edit the file using vi.
 
 ## vi "filename" 
    -- command to open a new file, if its doesn't exist it will create one.
    press i to enter into insert mode
    press esc to go back normal mode from insert mode
    :wq!-- to save and exit 
    :q!-- quit without saving
    :w! -- save only

 ## cat "filename"
  -- To open file, it shows what inside the file
  
 ## more "filename"
  -- if file is big, wanna scroll down use this command. just press enter to go down
  
 ## head "filename"
  -- It shows top lines of the file
  
 ## tail "filename"
  -- It shows bottom lines of the file 
  
 ## tail -f var/log/"filename" 
  -- Actually it shows the live logs of any file, ex: one file doing something so you can see the log of that file using this command.
  
 ## chmod (change mode)
   Its one of the important command, it modifies who can read, write, or create file/directory.
   
 ## chown [owner] : [group] "filename"
  -- Its changes ownership of group or file 
 
# System Monitoring Commands

## ps -ef 
 To check what are the processors are running on your system.
  ex: ps -ef | grep nginx - Find the specific process (nginx server)
  
## Top 
 Top is one of the important command for real-time system monitor, it shows which processor is consuming most resources. 
  It shows:
   CPU Usage
   Memory Usage
   Running Processes
   System Load
   
## df (disk free)
 -- The df command is used to check disk space usage on your system 
 
## Free 
 -- The free command is used to check memory usage (RAM + swap)
 
## Uptime
 -- shows total time system is up
 
## kill <PID>
  To kill any process that running on system

# Networking Commands

 ## ifconfig 
  -- ifconfig command is used to view and configure network interfaces | Check IP address, MAC address, and network status

## Ping 
 -- It helps you check if a host (IP or domain) is reachable and measures the latency (response time)
 
## netstat
 -- The netstat command is a classic tool for checking network connections, routing tables, and port usage on your system.
 
## traceroute
 -- traceroute is a super handy tool used to track the path your packets take to reach a destination (like a website or IP address).

## curl 
 curl is a command-line tool used to transfer data to or from a server using various protocols like HTTP, HTTPS, FTP, etc.

 It’s super handy in DevOps for testing APIs, downloading files, checking endpoints, etc. 

 most useful for interacting with URLs and APIs
 
 misc
 ## useradd 
  -- To add user
 ## passwd
  -- To add password to user
 ## userdel
  -- To delet the user
 ## awk 
  -- awk is important and powerful command to read and extract data.
    It reads input line by line, splits each line into fields (columns), and lets you perform actions on them.
    ex: ps -ef | grep nginx | awk -F " " '{print $2}' - this will find the process called nginx and print the second column/ string in the output

 ## set -e 
  -- exit the scirpt when there is an error
  
 ## set -x 
  -- debug mode
  
 ## set -o 
  -- pipe fail
  
 ## wget
  -- it's your go-to command-line tool for downloading files from the internet, especially in scripts, automation, or servers where there's no GUI.
  -- Useful in cron jobs and CI/CD for fetching dependencies
  -- Download single or multiple files
 ## find
  -- find is super powerful for locating files and directories
  -- find . -name "*.log" --> Searches in the current directory (.) for files ending in .log.
## sudo su- 
 -- when you want to switch to root user to perform some tasks
## su "username"
 -- switch to specific user 

  
