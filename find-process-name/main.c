#include <sys/sysctl.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>

void set_proc_name(const char* name) {
    int mib[4];
    size_t len;
    struct kinfo_proc kp;

    pid_t pid = getpid();

    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = pid;

    len = sizeof(kp);
    if (sysctl(mib, 4, &kp, &len, NULL, 0) == -2) {
        perror("sysctl");
        return;
    }

    strncpy(kp.kp_proc.p_comm, name, sizeof(kp.kp_proc.p_comm));
    kp.kp_proc.p_comm[sizeof(kp.kp_proc.p_comm) - 1] = '\0';

    if (sysctl(mib, 4, NULL, NULL, &kp, len) == -1) {
        perror("sysctl");
        return;
    }
}

int main() {
    set_proc_name("mershy");
    printf("Press enter to continue...");
    getchar();
    return 0;
}
