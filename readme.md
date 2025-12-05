README - Running and Testing the demo Web App
====================================================

This file summarizes the exact commands that worked for deploying the
demo web application on Windows with Tomcat 9 and MySQL, plus the
basic MySQL query to check the test user.

Environment overview
--------------------

Project folder (contains pom.xml):

  C:\Users\Risha\Desktop\College materials\Rutgers Semester 7\336\finalProject\336FinalProject\demo

Tomcat installation:

  C:\Users\Risha\Desktop\College materials\Rutgers Semester 7\336\Tomcat9\apache-tomcat-9.0.111

Maven Daemon (mvnd) folder:

  C:\Users\Risha\Desktop\maven-mvnd-1.0.3-windows-amd64


Section 1: Full deploy script (PowerShell, Windows)
---------------------------------------------------

Run these commands from a Windows PowerShell window.

1) Change into the project folder:

  cd "C:\Users\Risha\Desktop\College materials\Rutgers Semester 7\336\finalProject\336FinalProject\demo"

2) Tell PowerShell where Tomcat is:

  $env:CATALINA_HOME = "C:\Tomcat9\apache-tomcat-9.0.111"

3) Stop Tomcat (ignore errors if it is not running):

  & "$env:CATALINA_HOME\bin\shutdown.bat"
  Start-Sleep -Seconds 2

4) Remove old deployment and Tomcat cache:

  Remove-Item "$env:CATALINA_HOME\webapps\demo" -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item "$env:CATALINA_HOME\webapps\demo.war" -Force -ErrorAction SilentlyContinue
  Remove-Item "$env:CATALINA_HOME\work\Catalina\localhost\demo" -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item "$env:CATALINA_HOME\temp\*" -Force -ErrorAction SilentlyContinue

5) Build the project with mvnd (Maven Daemon):

  & "$env:USERPROFILE\Desktop\maven-mvnd-1.0.3-windows-amd64\bin\mvnd.cmd" -v
  & "$env:USERPROFILE\Desktop\maven-mvnd-1.0.3-windows-amd64\bin\mvnd.cmd" clean package

6) Sanity check: make sure the WAR exists:

  if (-not (Test-Path ".\target\demo.war")) {
    Write-Error "WAR not found: .\target\demo.war  (fix compile errors above, then rerun)"
    return
  }

7) Copy the WAR into Tomcat webapps:

  Copy-Item ".\target\demo.war" "$env:CATALINA_HOME\webapps\demo.war" -Force

8) Start Tomcat:

  & "$env:CATALINA_HOME\bin\startup.bat"

9) Show the last 60 lines of the newest catalina log:

  $log = Get-ChildItem "$env:CATALINA_HOME\logs\catalina*.log" | Sort-Object LastWriteTime | Select-Object -Last 1
  Get-Content $log.FullName -Tail 60

If deployment succeeds, the log will contain a line similar to:

  Deployment of web application archive [C:\...\webapps\demo.war] has finished in [xxx] ms

Then the app is available at:

  http://localhost:8081/demo/


Section 2: Quick manual deploy sanity commands
----------------------------------------------

These commands helped verify deployment when debugging.

1) Check that the WAR exists after the build:

  Get-ChildItem .\target

You should see "demo.war" in the listing.

2) Check which apps are currently in Tomcat webapps:

  $env:CATALINA_HOME = "C:\Users\Risha\Desktop\College materials\Rutgers Semester 7\336\Tomcat9\apache-tomcat-9.0.111"
  Get-ChildItem "$env:CATALINA_HOME\webapps"

You should see:

  docs
  examples
  host-manager
  manager
  ROOT
  demo.war      (after copying)
  demo          (after Tomcat expands demo.war)

3) If demo.war is missing in webapps, copy it manually and restart Tomcat:

  Copy-Item ".\target\demo.war" "$env:CATALINA_HOME\webapps\demo.war" -Force

  & "$env:CATALINA_HOME\bin\shutdown.bat"
  Start-Sleep -Seconds 2
  & "$env:CATALINA_HOME\bin\startup.bat"

  $log = Get-ChildItem "$env:CATALINA_HOME\logs\catalina*.log" | Sort-Object LastWriteTime | Select-Object -Last 1
  Get-Content $log.FullName -Tail 60


Section 3: MySQL query to check the test user
---------------------------------------------

In MySQL Workbench, the working pattern to verify the user row is:

  USE auction_app;
  SELECT * FROM `user`;

Or, in a single fully qualified query:

  SELECT * FROM auction_app.`user`;

This shows the contents of the "user" table, including the test credentials:

  Email:    testuser@example.com
  Password: testpass

These values are what the login form should accept.

(If using the MySQL command line client, connect first with:
  mysql -u root -p
then run the same USE and SELECT commands.)

End of file.
