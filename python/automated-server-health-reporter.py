import psutil


def get_system_stats():
    mem = psutil.virtual_memory()
    cpu = psutil.cpu_percent(interval=1)
    disk = psutil.disk_usage("/")

    return {
        "memo_per": mem.percent,
        "cpu": cpu,
        "disk_per": disk.percent
    }


def check_alert(stats: dict, threshold: float) -> None:
    for resource, usage in stats.items():
        if usage > threshold:
            print(f"Alert {resource} exceed threshold : {usage}")
        else:
            print(f"All okay")


if __name__== "__main__":
    stats = get_system_stats()    
    check_alert(stats,1)







