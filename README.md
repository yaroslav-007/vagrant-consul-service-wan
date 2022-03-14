# Deploy a consul service wan federated cluster

This code will deploy two consul servers in vagrant box. It will make WAN Federated cluster between them. 

## Prerequisite
Download and install vagrant according to your OS from https://www.vagrantup.com/downloads

## Usage

From the directory containing `Vagrantfile` run the following command:

```
vagrant up
```
 When the deploy is ready you should be able to access 
 - Consul UI of server 1: http://localhost:9000
 - Consul UI of server 2: http://localhost:9001
 



## License
[MIT](https://choosealicense.com/licenses/mit/)