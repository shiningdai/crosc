import psutil
import time
import csv
import argparse

def monitor(pid, interval, output_file):
    try:
        process = psutil.Process(pid)
    except psutil.NoSuchProcess:
        print(f"Process with PID {pid} not found.")
        return

    with open(output_file, 'w', newline='') as csvfile:
        # fieldnames = ['timestamp', 'cpu_percent', 'memory_b']
        fieldnames = ['timestamp', 'cpu_cnt', 'cpu_raw', 'cpu_avg', 'memory_kb']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()

        start_time = time.time()
        # time = 0
        # while time.time() - start_time < duration:
        while process is not None and process.is_running():
            try:
                # cpu = process.cpu_percent(interval=0.1)
                cpu_raw = process.cpu_percent(interval=0.1)
                cpu_count = psutil.cpu_count()
                cpu_avg = cpu_raw / cpu_count
                mem = process.memory_info().rss / 1024 # in kB /1024 KB, /1024 MB
                now = time.time() - start_time
                # time += interval
                # writer.writerow({'timestamp': f"{now:.2f}", 'cpu_percent': cpu, 'memory_b': f"{mem:.2f}"})
                # writer.writerow({'timestamp': f"{round(now)}", 'cpu_percent': cpu, 'memory_b': f"{mem:.2f}"})
                # writer.writerow({'timestamp': f"{round(now)}", 'cpu_raw': f"{cpu_raw:.2f}", 'cpu_avg': f"{cpu_avg:.2f}", 'memory_b': f"{mem:.2f}"})
                writer.writerow({'timestamp': f"{round(now)}", 'cpu_cnt': f"{cpu_count}", 'cpu_raw': f"{cpu_raw:.2f}", 'cpu_avg': f"{cpu_avg:.2f}", 'memory_kb': f"{mem:.2f}"})
                time.sleep(interval - 0.1)
            except psutil.NoSuchProcess:
                print("Process ended.")
                break

    print(f"Monitoring finished. Output written to {output_file}")

if __name__ == "__main__":
    '''
    Example usage:
        python tcr1_sysperf_monitor.py --pid 30222 --interval 1.0 --duration 60 --output output.csv

        python tcr1_sysperf_monitor.py --pid 30774 --output ../sysinfo/base_0520.csv
        python tcr1_sysperf_monitor.py --pid 30829 --output ../sysinfo/ours_0520.csv
    '''
    parser = argparse.ArgumentParser()
    parser.add_argument('--pid', type=int, required=True, help='Target process PID')
    parser.add_argument('--interval', type=float, default=1.0, help='Sampling interval in seconds')
    parser.add_argument('--output', type=str, default='output.csv', help='CSV file to store data')
    args = parser.parse_args()

    monitor(args.pid, args.interval, args.output)