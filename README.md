### Setting up Spark on K8s (Relevant as on March 14, 2026):

* Go to the official [Apache Spark download page](https://spark.apache.org/downloads.html) and:
	1. Choose a Spark release: E.g. `4.1.1 (Jan 09,2026)`
	2. Choose a package type: E.g. `Pre-built for Apache Hadoop and later with Spark Connect enabled`
* Depending on the options you chose above, you should see a hyperlink generated in:
	3. Download Spark: [spark-4.1.1-bin-hadoop3-connect.tgz](https://www.apache.org/dyn/closer.lua/spark/spark-4.1.1/spark-4.1.1-bin-hadoop3-connect.tgz)
* You need to click on the hyperlink and then on the next page, you should see a section like below:
	```text
		We suggest the following location for your download:

		https://dlcdn.apache.org/spark/spark-4.1.1/spark-4.1.1-bin-hadoop3-connect.tgz

		Alternate download locations are suggested below.
		...
	```
* Copy the link from that download section and download Spark via `curl` on your Terminal: 
	```shell
	→ curl -OL https://dlcdn.apache.org/spark/spark-4.1.1/spark-4.1.1-bin-hadoop3-connect.tgz
	% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
									Dload  Upload   Total   Spent    Left  Speed
	100  546M  100  546M    0     0  6901k      0  0:01:21  0:01:21 --:--:-- 12.2M

	→ ls -l
	total 1147120
	drwxr-xr-x@ 5 81045729  staff        160 Mar 14 19:53 code
	drwxr-xr-x@ 4 81045729  staff        128 Mar 14 19:53 data
	-rw-r--r--@ 1 81045729  staff       1874 Mar 14 19:53 README.md
	-rw-r--r--@ 1 81045729  staff  572746775 Mar 14 20:03 spark-4.1.1-bin-hadoop3-connect.tgz
	```
* Extract the tar file now and move the extracted folder to a different directory, if required:
	```shell
	→ tar -xzvf spark-4.1.1-bin-hadoop3-connect.tgz
	x spark-4.1.1-bin-hadoop3-connect/
	x spark-4.1.1-bin-hadoop3-connect/conf/
	x spark-4.1.1-bin-hadoop3-connect/conf/workers.template
	...
	x spark-4.1.1-bin-hadoop3-connect/bin/docker-image-tool.sh
	x spark-4.1.1-bin-hadoop3-connect/bin/spark-shell

	→ ls -l
	total 1147120
	drwxr-xr-x@  5 81045729  staff        160 Mar 14 19:53 code
	drwxr-xr-x@  4 81045729  staff        128 Mar 14 19:53 data
	-rw-r--r--@  1 81045729  staff       1874 Mar 14 19:53 README.md
	drwxr-xr-x@ 17 81045729  staff        544 Jan  2 17:55 spark-4.1.1-bin-hadoop3-connect
	-rw-r--r--@  1 81045729  staff  572746775 Mar 14 20:03 spark-4.1.1-bin-hadoop3-connect.tgz

	→ mv spark-4.1.1-bin-hadoop3-connect/ ../../

	→ ls -l ~/Documents/spark-4.1.1-bin-hadoop3-connect/
	total 176
	drwxr-xr-x@  31 81045729  staff    992 Jan  2 17:55 bin
	drwxr-xr-x@   9 81045729  staff    288 Jan  2 17:55 conf
	drwxr-xr-x@   6 81045729  staff    192 Jan  2 17:55 data
	drwxr-xr-x@   4 81045729  staff    128 Jan  2 17:55 examples
	drwxr-xr-x@ 289 81045729  staff   9248 Jan  2 17:55 jars
	drwxr-xr-x@   4 81045729  staff    128 Jan  2 17:55 kubernetes
	-rw-r--r--@   1 81045729  staff  22197 Jan  2 17:55 LICENSE
	drwxr-xr-x@  62 81045729  staff   1984 Jan  2 17:55 licenses
	-rw-r--r--@   1 81045729  staff  42646 Jan  2 17:55 NOTICE
	drwxr-xr-x@  22 81045729  staff    704 Jan  2 17:55 python
	drwxr-xr-x@   3 81045729  staff     96 Jan  2 17:55 R
	-rw-r--r--@   1 81045729  staff  12845 Jan  2 17:55 README.md
	-rw-r--r--@   1 81045729  staff    145 Jan  2 17:55 RELEASE
	drwxr-xr-x@  21 81045729  staff    672 Jan  2 17:55 sbin
	drwxr-xr-x@   3 81045729  staff     96 Jan  2 17:55 yarn
	```
* Now verify that spark is working as expected:
	```shell
	→ spark-submit --version
	WARNING: Using incubator modules: jdk.incubator.vector
	Welcome to
		____              __
		/ __/__  ___ _____/ /__
		_\ \/ _ \/ _ `/ __/  '_/
	/___/ .__/\_,_/_/ /_/\_\   version 4.1.1
		/_/
							
	Using Scala version 2.13.17, OpenJDK 64-Bit Server VM, 17.0.18
	Branch HEAD
	Compiled by user runner on 2026-01-02T11:55:02Z
	Revision c0690c763bafabd08e7079d1137fa0a769a05bae
	Url https://github.com/apache/spark
	Type --help for more information.
	```
* If you run into any errors at this point, checkout out the [troubleshooting section](#troubleshooting) for more details.

### Troubleshooting
1. `spark-submit --version` returns the below error:
	```shell
	→ spark-submit --version  
	Exception in thread "main" java.lang.UnsupportedClassVersionError: org/apache/spark/launcher/Main has been compiled by a more recent version of the Java Runtime (class file version 61.0), this version of the Java Runtime only recognizes class file versions up to 52.0
		at java.lang.ClassLoader.defineClass1(Native Method)
		at java.lang.ClassLoader.defineClass(ClassLoader.java:756)
		at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
		at java.net.URLClassLoader.defineClass(URLClassLoader.java:473)
		at java.net.URLClassLoader.access$100(URLClassLoader.java:74)
		at java.net.URLClassLoader$1.run(URLClassLoader.java:369)
		at java.net.URLClassLoader$1.run(URLClassLoader.java:363)
		at java.security.AccessController.doPrivileged(Native Method)
		at java.net.URLClassLoader.findClass(URLClassLoader.java:362)
		at java.lang.ClassLoader.loadClass(ClassLoader.java:418)
		at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:371)
		at java.lang.ClassLoader.loadClass(ClassLoader.java:351)
		at sun.launcher.LauncherHelper.checkAndLoadMain(LauncherHelper.java:642)
	/Users/81045729/Documents/spark-4.1.1-bin-hadoop3-connect//bin/spark-class: line 97: CMD: bad array subscript
	```

	* This usually indicates a mismatch in Java versions, in this case, Spark 4.1.1 is compiled for Java 17 (class file version 61) but our `spark-submit` was running with Java 8 (class file version 52), so we needed to install Java 17+ and make sure Spark uses that JDK. To verify your java version, run the below command:
	```shell
	→ java -version
	java version "1.8.0_451"
	Java(TM) SE Runtime Environment (build 1.8.0_451-b10)
	Java HotSpot(TM) 64-Bit Server VM (build 25.451-b10, mixed mode)

	→ /usr/libexec/java_home -V 
	java_home: unrecognized option `- '
	Matching Java Virtual Machines (1):
		1.8.451.10 (arm64) "Oracle Corporation" - "Java" /Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home
	/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home
	```

	* Now we install Java 17 on our Mac OS via homebrew:
	```shell
	→ brew install --cask temurin@17                                                      
	✔︎ JSON API formula.jws.json                                                                                                                                     Downloaded   31.9MB/ 31.9MB
	✔︎ JSON API cask.jws.json                                                                                                                                        Downloaded   15.4MB/ 15.4MB
	==> Fetching downloads for: temurin@17
	✔︎ Cask temurin@17 (17.0.18,8)                                                                                                                                   Verified    186.1MB/186.1MB
	==> Installing Cask temurin@17
	==> Running installer for temurin@17 with `sudo` (which may request your password)...
	Password:
	installer: Package name is Eclipse Temurin
	installer: Installing at base path /
	installer: The install was successful.
	🍺  temurin@17 was successfully installed!
	```

	* Verify the versions of Java available:
	```shell
	→ /usr/libexec/java_home -V     
	Matching Java Virtual Machines (2):
		17.0.18 (arm64) "Eclipse Adoptium" - "OpenJDK 17.0.18" /Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
		1.8.451.10 (arm64) "Oracle Corporation" - "Java" /Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home
	/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
	```

	* Now instead of changing the global `JAVA_HOME`, we played it safe by simply pointing Spark to Java 17. To do this:
		* Navigate to the Spark directory & create a new `spark-env.sh` if it does not exist:
			```shell
			→ cd ../../spark-4.1.1-bin-hadoop3-connect/
			→ cp conf/spark-env.sh.template conf/spark-env.sh
			```
		* Add the below entries to your `conf/spark-env.sh` and save it:
			```shell
			export JAVA_HOME=$(/usr/libexec/java_home -v 17)
			```
	
	* Now Spark should work as expected:
	```shell
	→ spark-submit --version
	WARNING: Using incubator modules: jdk.incubator.vector
	Welcome to
		____              __
		/ __/__  ___ _____/ /__
		_\ \/ _ \/ _ `/ __/  '_/
	/___/ .__/\_,_/_/ /_/\_\   version 4.1.1
		/_/
							
	Using Scala version 2.13.17, OpenJDK 64-Bit Server VM, 17.0.18
	Branch HEAD
	Compiled by user runner on 2026-01-02T11:55:02Z
	Revision c0690c763bafabd08e7079d1137fa0a769a05bae
	Url https://github.com/apache/spark
	Type --help for more information.
	```

### hadoop-and-pyspark-projects
This is a placeholder for all my Hadoop projects including PySpark, Hive, Kafka etc. The files and folders are named in a way that helps identifying the corresponding code and data easily. Forexample, for the code transactions.py, there is a folder named transactions under /data which contains all necessary datasets used for the code.

Project 1 - To identify:
		a) All transactions for each account that have the same transaction_source and same transaction_amount in both months
		b) All accounts that have transactions in either month but not both.
The datasets are for the months August and September and have 2000 records each. The code is written in PySpark. The logic is implemented using RDDs, without resorting to the use of DataFrames.

Project 2 - This project is done to analyse the data for a large retail chain based in US. The purpose of this project is to identify the KPIs and analyse them to help reduce fraud and also get deeper business insights. For this reason, we have taken into account a subset of the orders data, products data, customers data and departments data.
No Personally Indentifiable Information (PII) has been used to analyse the datasets. We are trying to determine the following:
		- find the state-wise distribution of customers i.e. number of customers from each state
		- find all unique customer details for suspected fraud transactions (orders.paymentStatus = SUSPECTED_FRAUD)
		- find total amount and total number of orders for each of value of paymentStatus
		- find number of products that are from the brands - Nike, Adidas, Reebok, Puma, Majestic, Under Armour and Fitbit
		- find the number of products that below to different price ranges i.e. $0-$20, $20-$40 etc. Use dataframes for this.
		- find the productId, productDescription and price of the top 20 highest and lowest selling items
