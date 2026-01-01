module "compute_engine" {
  source = "./modules/compute_engine"
  vm1_ip = module.network.vm1_ip_address
  network_name = module.network.network_name
  subnetwork_name = module.network.subnetwork_name
}

module "network" {
  source        = "./modules/network"
  mig_instance_group = module.compute_engine.mig_instance_group
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