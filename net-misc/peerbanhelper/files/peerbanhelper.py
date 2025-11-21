#! /usr/bin/python
# coding=utf-8

import sys, os
import subprocess
import logging
from time import sleep
import signal
import socket

logger = logging.getLogger("peerbanhelper")

Global_Options = {
    "daemon": False,
    "verbose": False
}

PORT=9898
MAX_SLEEP_TIME=5
DATA_DIR=os.path.join(os.environ.get("HOME"), R".peerbanhelper")
JAR_PATH=R"/opt/peerbanhelper/PeerBanHelper.jar"


def print_usage():
    name=os.path.basename(__file__).split('.')[0]
    print("unknown parameters: %s" % " ".join(sys.argv[1:]))
    print("\nUsage: %s [ option ] command" % name)
    print("\n    option:")
    print("\n    --daemon: run as daemon")
    print("\n    --verbose: print peerbanhelper output to stdout")
    print("\n    command: [ start | stop ]\n")


def test_run() -> tuple:
    cmd = ("pgrep", "-f", " -jar %s nogui" % JAR_PATH)
    ps_ret = subprocess.run(
        cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, encoding="utf8")

    return tuple(int(pid) for pid in ps_ret.stdout.split('\n') if pid.isdigit())


def stop_task(log_level=logging.INFO) -> bool:
    logger.setLevel(log_level)
    logger.info("stopping peerbanhelper ...")

    pids, ret = test_run(), True
    if pids:
        for pid in pids:
            os.kill(pid, signal.SIGTERM)

        success = False
        for i in range(0, MAX_SLEEP_TIME):
            sleep(1)
            if not test_run():
                success = True
                break
        else:
            for pid in test_run():
                os.kill(pid, signal.SIGKILL)

        if success:
            logger.info("peerbanhelper stop success.")
        else:
            logger.error("peerbanhelper stop failed. use SIGKILL(kill -9) retry ...")
            for i in range(0, MAX_SLEEP_TIME):
                sleep(1)
                if not test_run():
                    logger.error("peerbanhelper SIGKILL(kill -9) success.")
                    break
            else:
                ret = False
                logger.error("peerbanhelper SIGKILL(kill -9) failed.")

    else:
        logger.info("peerbanhelper not running.")

    return ret


def start_task(log_level=logging.INFO) -> bool:
    ret = False

    if not stop_task(logging.WARN):
        logger.error("peerbanhelper start failed. because running process not stop.")
        return ret

    logger.setLevel(log_level)
    logger.info("peerbanhelper starting ...")

    cmd = ("java", R"-Dpbh.datadir=%s" % os.path.join(DATA_DIR, "data"),
           R"-Dpbh.logsdir=%s" % os.path.join(DATA_DIR, "log"),
           "-Dpbh.log.level=WARN", "-Xmx512M", "-XX:+UseG1GC",
           "-XX:+UseStringDeduplication", "-XX:+ShrinkHeapInSteps",
           "-jar", JAR_PATH, "nogui")

    if Global_Options["verbose"]:
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, encoding="utf8")
    else:
        proc = subprocess.Popen(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    success = False
    for i in range(0, MAX_SLEEP_TIME):
        sleep(1)
        if test_run():
            success = True
            break

    if success:
        ret = True
        logger.info("peerbanhelper start success.")
    else:
        if Global_Options["verbose"]:
            try:
                outs, _ = proc.communicate(timeout=1)
            except subprocess.TimeoutExpired:
                proc.kill()
                outs, _ = proc.communicate()
            logger.critical("peerbanhelper start failed. subprocess.run stdout: %s\n" % outs)
        else:
            print("peerbanhelper start failed. use --verbose to get more information\n")

    return ret


def run_as_daemon():
    def handler(signum, frame):
        stop_task(logging.WARN)
        print("peerbanhelper daemon stoped.")
        sys.exit(0)

    def test_port() -> bool:
        ret = False
        try:
            with socket.create_connection(("127.0.0.1", PORT), timeout=3):
                ret = True
        except Exception:
            pass
        return ret

    print("peerbanhelper running as daemon.")
    signal.signal(signal.SIGTERM, handler)
    signal.signal(signal.SIGINT, handler)
    while True:
        sleep(180)
        if not test_port():
            start_task(logging.WARN)


def read_global_options(argv: list[str]) -> list[str]:
    global Global_Options

    if "--daemon" in argv:
        Global_Options["daemon"] = True
        argv.remove("--daemon")
    if "--verbose" in argv:
        Global_Options["verbose"] = True
        argv.remove("--verbose")

    return argv


if __name__ == "__main__":
    logging.basicConfig(format="%(message)s", level=logging.INFO)

    argv = read_global_options(sys.argv)

    if len(argv) > 1:
        match argv[1]:
            case "start":
                start_task()
                if Global_Options["daemon"]: run_as_daemon()
            case "stop":
                stop_task()
            case _:
                print_usage()
    else:
        print_usage()
