terraform {
  required_version = "> 1.5"
}
#-----------------------------------------
# Default provider: Kubernetes
#-----------------------------------------
provider "kubernetes" {
  #kubeconfig file, if using K3S set the path
  #config_path = "/etc/rancher/k3s/k3s.yaml"
  #Context to choose from the config file. Change if not default.
  # Find with "kubectl config view"
  # or "kubectl config get-contexts"
# config_context = "kind-c1"
}
#-----------------------------------------
# KUBERNETES: Deploy App
#-----------------------------------------
resource "kubernetes_deployment" "color" {
    metadata {
        name = "color-blue-dep"
        labels = {
            app   = "color"
            color = "blue"
        } //labels
    } //metadata
    
    spec {
        selector {
            match_labels = {
                app   = "color"
                color = "blue"
            } //match_labels
        } //selector
        #Number of replicas
        replicas = 2
        #Template for the creation of the pod
        template { 
            metadata {
                labels = {
                    app   = "color"
                    color = "blue"
                } //labels
            } //metadata
            spec {
                container {
                    image = "itwonderlab/color"   #Docker image name
                    name  = "color-blue"          #Name of the container specified as a DNS_LABEL. Each container in a pod must have a unique name (DNS_LABEL).
                    
                    #Block of string name and value pairs to set in the container's environment
                    env { 
                        name = "COLOR"
                        value = "blue"
                    } //env
                    
                    #List of ports to expose from the container.
                    port { 
                        container_port = 8080
                    }//port          
                    
                    resources {
                        requests = {
                            cpu    = "250m"
                            memory = "50Mi"
                        } //requests
                    } //resources
                } //container
            } //spec
        } //template
    } //spec
} //resource
#-------------------------------------------------
# KUBERNETES: Add a NodePort
#-------------------------------------------------
resource "kubernetes_service" "color-service-np" {
  metadata {
    name = "color-service-np"
  } //metadata
  spec {
    selector = {
      app = "color"
    } //selector
    session_affinity = "ClientIP"
    port {
      port      = 8080 
      node_port = 30085
    } //port
    type = "NodePort"
  } //spec
} //resource