#!/usr/bin/env python3
import argparse
import os
import subprocess
import sys


def run(cmd, check=True, capture_output=False):
    return subprocess.run(
        cmd,
        check=check,
        capture_output=capture_output,
        text=True,
    )


def tmux_has_session(session):
    return subprocess.run(
        ["tmux", "has-session", "-t", session],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    ).returncode == 0


def tmux_window_exists(session, window):
    p = run(
        ["tmux", "list-windows", "-t", session],
        capture_output=True,
        check=False,
    )
    return any(f": {window}" in line for line in p.stdout.splitlines())


def get_newest_pane(session, window):
    p = run(
        [
            "tmux",
            "list-panes",
            "-t",
            f"{session}:{window}",
            "-F",
            "#{pane_id}",
        ],
        capture_output=True,
    )
    return p.stdout.strip().splitlines()[-1]


def main():
    parser = argparse.ArgumentParser(
        description="Launch remote command in tmux with GPU selection"
    )
    parser.add_argument(
        "target",
        help="Target in form @v5g0 (host v5, gpu 0)",
    )
    parser.add_argument(
        "command",
        nargs=argparse.REMAINDER,
        help="Command to run remotely",
    )

    args = parser.parse_args()

    if not args.command:
        parser.error("No command specified")

    # --- Parse target ---
    spec = args.target.lstrip("@")     # v5g0
    host = spec.split("g")[0]           # v5
    gpu = spec.split("g")[-1]           # 0

    session = "light-mesh"
    window = spec
    cwd = os.getcwd()
    cmd = " ".join(args.command)

    # --- tmux session ---
    if not tmux_has_session(session):
        run(["tmux", "new-session", "-d", "-s", session])

    # --- tmux window / pane ---
    if tmux_window_exists(session, window):
        run(["tmux", "split-window", "-h", "-t", f"{session}:{window}"])
    else:
        run(["tmux", "new-window", "-t", session, "-n", window])

    run(["tmux", "select-layout", "-t", f"{session}:{window}", "tiled"])

    pane = get_newest_pane(session, window)

    remote_cmd = f"/pure/f1/project/light-mesh/bin/run {cmd}"

    ssh_cmd = (
        f"ssh -t {host} "
        f"'cd \"{cwd}\" && CUDA_VISIBLE_DEVICES={gpu} {remote_cmd}; exec $SHELL'"
    )

    run(["tmux", "send-keys", "-t", pane, ssh_cmd, "C-m"])

    # --- attach ---
    # run(["tmux", "attach", "-t", session], check=False)


if __name__ == "__main__":
    main()
