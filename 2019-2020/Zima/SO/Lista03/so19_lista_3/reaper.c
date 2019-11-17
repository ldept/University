#include "csapp.h"

static pid_t spawn(void (*fn)(void)) {
  pid_t pid = Fork();
  if (pid == 0) {
    fn();
    printf("(%d) I'm done!\n", getpid());
    exit(EXIT_SUCCESS);
  }
  return pid;
}

static void grandchild(void) {
  printf("(%d) Waiting for signal!\n", getpid());
  /* TODO: Something is missing here! */
  void sigint_handler(){
    return;
  }
  signal(SIGINT, sigint_handler);
  pause();
  printf("(%d) Got the signal!\n", getpid());
}

static void child(void) {

  setpgid(getpid(),getpid());
  pid_t pid = spawn(grandchild);
  printf("(%d) Grandchild (%d) spawned!\n", getpid(), pid);
}

/* Runs command "ps -o pid,ppid,pgrp,stat,cmd" using execve(2). */ 
static void ps(void) {
  /* TODO: Something is missing here! */
  char* argv[] = {
    "/bin/ps", "-o", "pid,ppid,pgrp,stat,cmd", NULL
  };

  execve(argv[0], argv, NULL);
}

int main(void) {
  /* set yourself a reaper */
  Prctl(PR_SET_CHILD_SUBREAPER, 1);
  printf("(%d) I'm a reaper now!\n", getpid());

  pid_t ps_pid, pgrp;
  int status;

  /* TODO: Something is missing here! */
  pgrp = spawn(child);
  waitpid(pgrp, NULL, 0);

  
  printf("\n");
  ps_pid = spawn(ps);
  waitpid(ps_pid, NULL, 0);
  printf("\n");
  
  kill(-pgrp, SIGINT);
  printf("(%d) SIGINT sent to group %d \n", getpid(), pgrp);

  
  wait(&status);
  printf("(%d) Grandchild exit code %d \n", getpid(), status);

  return EXIT_SUCCESS;
}
