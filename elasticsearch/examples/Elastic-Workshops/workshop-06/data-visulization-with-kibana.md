## Data Visulization with Kibana

from [kibana](https://catalog.workshops.aws/eks-logging/en-US/opensearch/3-kibana)

### Create dataset

- ***Run log generator***

```
docker run -p 80:80 -d madebybk/nextjs-random-json-logger:latest
```
- ***Go to [localhost](http://localhost:80) in browser.***

![Random Log GeneratorEKS Workshop 02](images/random-log-genera-to-EKS-workshop-01.png)

- ***Then set value for `Records per second` and `Duration of the logs` field then submit.***

![Random Log GeneratorEKS Workshop 02](images/random-log-genera-to-EKS-workshop-02.png)

- ***Will generate random logs messages:***

```json
{"level":"info","error_code":"err_5","request_method":"GET","message":"This is a sample log message no. 56","request_uri":"/api/logger","timestamp":"2023-05-10T16:34:53.187Z[UTC]","status":"OK","server_protocol":"HTTP/1.1"}
{"level":"info","error_code":"err_5","request_method":"GET","message":"This is a sample log message no. 57","request_uri":"/api/logger","timestamp":"2023-05-10T16:34:54.187Z[UTC]","status":"OK","server_protocol":"HTTP/1.1"}
{"level":"info","error_code":"err_4","request_method":"GET","message":"This is a sample log message no. 58","request_uri":"/api/logger","timestamp":"2023-05-10T16:34:55.188Z[UTC]","status":"WARN","server_protocol":"HTTP/1.1"}
{"level":"info","error_code":"err_2","request_method":"GET","message":"This is a sample log message no. 59","request_uri":"/api/logger","timestamp":"2023-05-10T16:34:56.187Z[UTC]","status":"WARN","server_protocol":"HTTP/1.1"}
{"level":"info","error_code":"err_1","request_method":"GET","message":"This is a sample log message no. 60","request_uri":"/api/logger","timestamp":"2023-05-10T16:34:57.187Z[UTC]","status":"OK","server_protocol":"HTTP/1.1"}
```

---

### Index log data

- ***Go to `Home > Upload a file`***

![kibana-upload-file-01](images/kibana-upload-file-01.png)

- ***In `Upload file` tab click `Select or drag and drop a file` select log file.***

![kibana-upload-file-02](images/kibana-upload-file-02.png)

- ***Click `Import` buttom.***

![kibana-upload-file-03](images/kibana-upload-file-03.png)

- ***Enter name for index and click `Import`***

![kibana-upload-file-04](images/kibana-upload-file-04.png)

- ***Now click on `View index in Discover` to view imported logs***

![kibana-upload-file-05](images/kibana-upload-file-05.png)

- ***Import completed***

![kibana-upload-file-06](images/kibana-upload-file-06.png)

---

1. 

2. Configuring an Index pattern


#### Verifying Data using Discover

3. 

#### Creating Graphs with Visualize && Dashboards

##### Visualize (Pie)

4. 

##### Visualize (Area)

5. 
