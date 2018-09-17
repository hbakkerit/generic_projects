#!/usr/bin/env bash
echo "Setting Azure provider environment variables for Terraform..."
read -e -p 'please input your Azure Subscription ID: '  ARM_SUBSCRIPTION_ID 
read -e -p 'please input your Azure Client ID: '  ARM_CLIENT_ID 
read -e -p 'please input your Azure Client ID: '  ARM_CLIENT_SECRET 
read -e -p 'please input your Azure Tenant ID: '  ARM_TENANT_ID 