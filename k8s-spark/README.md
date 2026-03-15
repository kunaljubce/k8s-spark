### Setting up Spark on K8s (Relevant as on March 14, 2026):
* Clone this repository which contains a working Dockerfile:
	```shell
	→ git clone https://github.com/kunaljubce/k8s-spark.git
	```
* Build your Spark image on local:
	```shell
	→ docker build -t spark:v4.1.1 .
	[+] Building 116.5s (8/8) FINISHED                                                                                                                                    docker:desktop-linux
	=> [internal] load build definition from Dockerfile                                                                                                                                  0.0s
	=> => transferring dockerfile: 802B                                                                                                                                                  0.0s
	=> [internal] load metadata for docker.io/library/openjdk:17.0.1-jdk-slim                                                                                                            2.5s
	=> [internal] load .dockerignore                                                                                                                                                     0.0s
	=> => transferring context: 2B                                                                                                                                                       0.0s
	=> [1/4] FROM docker.io/library/openjdk:17.0.1-jdk-slim@sha256:fc5fa503124ba7021bbf8cb3718bf08791590d0aa2295c7cc551de65f9919290                                                     20.4s
	=> => resolve docker.io/library/openjdk:17.0.1-jdk-slim@sha256:fc5fa503124ba7021bbf8cb3718bf08791590d0aa2295c7cc551de65f9919290                                                      0.0s
	=> => sha256:793a64b0fc1713036909cd54095428181b63814fde3deff4542fa3a1ff57dbdc 186.14MB / 186.14MB                                                                                   18.8s
	=> => sha256:2c3380d13c6c3ddd0cc31ece5496ad1481500cb07b7feb31c81bc907a9a1ad71 1.57MB / 1.57MB                                                                                        6.8s
	=> => sha256:927a35006d93ea08499b57046904046d7926cd76fb17be193e3e74f56d634a08 30.04MB / 30.04MB                                                                                     10.2s
	=> => extracting sha256:927a35006d93ea08499b57046904046d7926cd76fb17be193e3e74f56d634a08                                                                                             0.5s
	=> => extracting sha256:2c3380d13c6c3ddd0cc31ece5496ad1481500cb07b7feb31c81bc907a9a1ad71                                                                                             0.0s
	=> => extracting sha256:793a64b0fc1713036909cd54095428181b63814fde3deff4542fa3a1ff57dbdc                                                                                             1.6s
	=> [2/4] RUN apt-get update && apt-get install -y curl                                                                                                                              11.1s
	=> [3/4] RUN curl -O https://dlcdn.apache.org/spark/spark-4.1.1/spark-4.1.1-bin-hadoop3-connect.tgz &&   tar -xzf spark-4.1.1-bin-hadoop3-connect.tgz &&   mv spark-4.1.1-bin-hado  61.6s 
	=> [4/4] WORKDIR /spark/work-dir                                                                                                                                                     0.1s 
	=> exporting to image                                                                                                                                                               20.6s 
	=> => exporting layers                                                                                                                                                              17.7s 
	=> => exporting manifest sha256:77657e4ad0f66c355c718426db9d085312f51923892efa341ecfdf2c26374b56                                                                                     0.0s 
	=> => exporting config sha256:862c62d0e22fc8fcc3af46ca0b624398d00f07c1cd4db8435c70fe59be7a4c8a                                                                                       0.0s 
	=> => exporting attestation manifest sha256:67cadaa77b993dd4a2b8c13c1e30b2eaa195a5e3a4c6c6d4cdfb306b0972c933                                                                         0.0s
	=> => exporting manifest list sha256:956db75c8394bbfb4425b97fdb509149847f980fb92a3c82b6c5007596eb5f78                                                                                0.0s
	=> => naming to docker.io/library/spark:v4.1.1                                                                                                                                       0.0s
	=> => unpacking to docker.io/library/spark:v4.1.1                                                                                                                                    2.8s

	2 warnings found (use docker --debug to expand):
	- LegacyKeyValueFormat: "ENV key=value" should be used instead of legacy "ENV key value" format (line 14)
	- LegacyKeyValueFormat: "ENV key=value" should be used instead of legacy "ENV key value" format (line 15)
	```
* Now we need to configure Spark to use Kubernetes as its cluster manager. Create a `spark-defaults.conf` file in your Spark configuration directory:
	```shell
	→ cp $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf
	```
* Add the following configurations to this file:
	```text
	spark.master k8s://https://<kubernetes-api-server-url> # Run `kubectl get cluster-info` -> Kubernetes control plane is running at <kubernetes-api-server-url>
	spark.kubernetes.container.image <your-spark-image> # In this case, the spark image would be `spark:v4.1.1` as mentioned during `docker build ...`
	spark.kubernetes.namespace spark
	spark.kubernetes.authenticate.driver.serviceAccountName spark
	spark.kubernetes.authenticate.executor.serviceAccountName spark
	```
* Note that we already have the K8s service level declarations inside `k8s-spark/` dir in our repo, we just need to apply all of them to create a service account, role binding, PVC, and a history server for Spark:
	```shell
	→ kubectl apply -f k8s-spark/ -R
    persistentvolumeclaim/spark-event-log-pvc unchanged
    configmap/spark-history-server-config unchanged
    deployment.apps/spark-history-server created
    service/spark-history-server created
    serviceaccount/spark unchanged
    clusterrolebinding.rbac.authorization.k8s.io/spark-role unchanged
	```
* Now we are ready to submit one of examples to the cluster:
	```
	$SPARK_HOME/bin/spark-submit \                             
		--master k8s://https://127.0.0.1:6443 \
		--deploy-mode cluster \
		--name spark-pi \
		--class org.apache.spark.examples.SparkPi \
		--conf spark.executor.instances=3 \
		--conf spark.kubernetes.container.image=spark:v4.1.1 \
		--conf spark.kubernetes.namespace=spark \
		local:///spark/examples/jars/spark-examples_2.13-4.1.1.jar
	```
