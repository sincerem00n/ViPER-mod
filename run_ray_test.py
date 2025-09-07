import ray
ray.init(num_cpus=4, num_gpus=1, _system_config={"raylet_start_wait_time_s": 60})
print(ray.cluster_resources())
ray.shutdown()