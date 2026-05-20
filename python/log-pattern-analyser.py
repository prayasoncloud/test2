import collections
import gzip
import re
from pathlib import Path

LOG_PATTERN = re.compile(
    r'(?P<ts>\d{4}-\d{2}-\d{2}T\S+)'  
    r'\s+\[(?P<lvl>ERROR|INFO|WARN)\]'  
    r'\s+(?P<msg>.+)'
)


def parse_logs(path) -> list[dict]:
    result = []
    opener = gzip.open if path.suffix == ".gz" else open

    with opener(path, "rt", encoding="utf-8") as f:
        for line in f:
            match = LOG_PATTERN.search(line)
            if match:
                result.append(match.groupdict())
    return result


def top_errors(logs: list[dict], n: int = 10) -> list:
    error_msgs = []
    for log in logs:
        if log["lvl"] == "ERROR":
            error_msgs.append(log["msg"])

    counters = collections.Counter(error_msgs)
    return counters.most_common(n)


def print_report(log_file):
    print("*** Parsing a log file*********")
    path = Path(log_file)
    if not path.exists():
        print("File not found")
        return  
    logs = parse_logs(path)

    frequent_errors = top_errors(logs, n=5)

    if not frequent_errors:
        print("No ERROR logs found.")
    else:
        for msg, count in frequent_errors:
            print(f"[{count} times]: {msg}")

if __name__ == "__main__":
    target_log_file = "test_app.log" 
    print_report(target_log_file)