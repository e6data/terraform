

prefix                                 = "e6data"

region                                 = "eastus"

workspace_name                          =   "e6dataworkspace"                  #Name of the e6data workspace to be created.

subscription_id                         =   "244ad77a-91e4-4a8e-9193-835d79ac55e2"  #subscription id where the eks cluster is present
aks_resource_group_name                 =   "aks-poc"              #The name of the resource group in which aks cluster is present.
aks_cluster_name                        =   "connect-poc"          #The name of the Kubernetes cluster to deploy e6data workspace.

kube_version                            =   "1.26.6"               #Version of Kubernetes used for the Agents.
kubernetes_namespace                    =   "raaj"                 #Value of the Kubernetes namespace to deploy the e6data workspace.

vnet_name                               =   "akspocvnet596"         #The name of the vnet where this Node Pool should exist.
subnet_name                             =   "default"               #The name of the Subnet where this Node Pool should exist.
zones                                   =   ["1","2","3"]           #Specifies a list of Availability Zones in which this Kubernetes Cluster Node Pool should be located

vm_size                                 =   "Standard_DS2_v2"       #The SKU which should be used for the Virtual Machines used in this Node Pool. 
min_number_of_nodes                     =   "1"                     #The minimum number of nodes which should exist within this Node Pool. Valid values are between 0 and 1000 and must be less than or equal to max_number_of_nodes
max_number_of_nodes                     =   "5"                     #The maximum number of nodes which should exist within this Node Pool. Valid values are between 0 and 1000 and must be greater than or equal to min_number_of_nodes
priority                                =   "Spot"                  #The Priority for Virtual Machines within the Virtual Machine Scale Set that powers this Node Pool. Possible values are Regular and Spot
spot_max_price                          =   -1                      #The maximum price you're willing to pay in USD per Virtual Machine. Valid values are -1 (the current on-demand price for a Virtual Machine) or a positive value with up to five decimal places   
eviction_policy                         =   "Deallocate"            #The Eviction Policy which should be used for Virtual Machines within the Virtual Machine Scale Set powering this Node Pool. Possible values are Deallocate and Delete

e6data_app_secret_expiration_time       =   "2400h"                 # A relative duration for which the password is valid until, for example 240h (10 days) or 2400h30m

data_storage_account_name               =   "e6tpcdsdata"           #Name of the storage account where the data is present that the e6data engine queries and therefore, require read access to
data_resource_group_name                =   "e6data-common"         #Name of the resource group where data storage account is present
list_of_containers                      =   ["*"]                   #Containers in the storage account where the data is present that the e6data engine queries and therefore, require read access to.Default is ["*"] which means all containers, it is advisable to change this.

helm_chart_version                      =   "2.0.7"                 #e6data workspace Helm chart version to be used


cost_tags = {
  App = "e6data"
}

# ##############################################

# data_storage_account    = "e6dataengine"
# data_resource_group     = "e6data-common"
# cluster_name            = "engine"
# kube_version            = "1.27.9"
# private_cluster_enabled = "false"
# resource_group_name     = "e6data-common"
# admin_group_object_ids  = ["c436c2ee-18b7-4130-acc4-d7a01fe6ee7e"]
# engine_namespaces       = ["e6data"]



# container_names = ["ci", "devcore", "regression"]
# cidr_block      = ["10.210.0.0/16"]
# env             = "e6engine"

# ###Default Node pool variables
# default_node_pool_min_size       = 1
# default_node_pool_max_size       = 20
# default_node_pool_vm_size        = "Standard_B2s"
# default_node_pool_node_count     = 1
# default_node_pool_name           = "default"
# scale_down_unneeded              = "1m"
# scale_down_unready               = "1m"
# scale_down_utilization_threshold = "0.2"
# scale_down_delay_after_add       = "1m"


# workspace_name       = "dev"
# vm_size              = "Standard_D32plds_v5"
# enable_auto_scaling  = true
# min_size             = 0
# max_size             = 200
# zones                = ["1", "2", "3"]
# priority             = "Spot"
# spot_max_price       = -1
# spot_eviction_policy = "Deallocate"
# kubernetes_namespace = "dev"
# helm_chart_version   = "2.0.7"

# ###blob full access
# e6data_blob_full_access_secret_expiration_time = "7200h"

# # azure container registry variables
# acr_name = "e6labs"
# acr_rg   = "e6data-common"

