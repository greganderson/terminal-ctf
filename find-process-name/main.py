import ctypes
import multiprocessing
import os
import sys
import time

def worker_process(pid, stop):
    print(f"Process {pid} started with PID {os.getpid()}")
    while not stop.is_set():
        time.sleep(1)
    print(f"Process {pid} completed")

def parent_process():
    n = 50
    stop = multiprocessing.Event()
    processes = []
    for i in range(n):
        process = multiprocessing.Process(target = worker_process, args = (i,stop))
        process.name = f"process #{i}"
        process.start()
        processes.append(process)

    print("Processes have been created")
    input("Press Enter to terminate all processes...")
    stop.set()

    for p in processes:
        p.join()

    print("All processes have been killed")

def main():
    new_name = "mershy"
    libc = ctypes.cdll.LoadLibrary("libc.dylib")
    buff = ctypes.create_string_buffer(len(new_name) + 1)
    buff.value = new_name.encode("utf-8")
    libc.prctl(15, ctypes.byref(buff), 0, 0, 0)

if __name__ == "__main__":
    main()
    input("Press enter to quit...")
    #parent_process()
