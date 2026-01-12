module "network" {
  source        = "./modules/network"
  mig_instance_group = module.compute_engine.mig_instance_group
}

module "compute_engine" {
  source = "./modules/compute_engine"
  vm1_ip = module.network.vm1_ip_address
  network_name = module.network.network_name
  subnetwork_name = module.network.subnetwork_name
}

module "sql" {
  source = "./modules/cloud_sql"
  sql_database = var.sql_database
  sql_password = var.sql_password
  sql_user = var.sql_user
  network_name = module.network.network_name
}

module "buckets" {
  source = "./modules/buckets"
}

module "kubernetes" {
  source     = "./modules/kubernetes"
  project_id = var.project_id

  network_id                     = module.network.network_id
  subnet_id                      = module.network.subnet_id
  pods_secondary_range_name      = module.network.pods_secondary_range_name
  services_secondary_range_name  = module.network.services_secondary_range_name
}

module "registry" {
  source        = "./modules/registry"
}

module "pubsub" {
  source = "./modules/pubsub"
}

module "redis" {
  source  = "./modules/redis"
  network = module.network.network_id
}

module "monitoring" {
  source              = "./modules/monitoring"
  project_id          = var.project_id
  notification_email  = var.notification_email
}