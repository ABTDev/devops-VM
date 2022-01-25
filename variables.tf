variable "owner" {
    description = "Owner of the resources being deployed."
    default = "ABTdevops"
}

variable "env" {
    description = "Environment classification for the resources deployed."
    default = "Devops"
}

variable "region" {
    description = "Azure region"
    default = "eastus2"
}

variable "vmcount" {
    description = "Number of VMs to deploy."
    #default = 1
}

variable "namePrefix" {
    description = "A prefix for the servername."
    default = "ABTdev"
}

variable "username" {
    description = "Username for the server login."
    default = "ABTdevops"
}

variable "pass" {
    description = "Password for the server login."
}

variable "vmSize" {
    description = "Enter desired Azure size. (Standard_A2_v2, Standard_D2_v2, Standard_B1MS, etc.)"
    default = "Standard_B1MS"
}