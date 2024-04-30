<?php

$process = proc_open(
    sprintf("%s -r %s", escapeshellcmd(PHP_BINARY), escapeshellarg($argv[1])),
    [
        0 => ["pipe", "r"], // stdin
        1 => ["pipe", "w"], // stdout
        2 => ["pipe", "w"], // stderr
    ],
    $pipes,
    getcwd(),
    getenv()
);

if (is_resource($process)) {
    // Close the standard input immediately if not used.
    fclose($pipes[0]);

    // Set the pipes to non-blocking mode to enable live reading.
    stream_set_blocking($pipes[1], false);
    stream_set_blocking($pipes[2], false);

    while ($info = proc_get_status($process)) {
        // Read from stdout.
        if ($stdout = stream_get_contents($pipes[1])) {
            echo $stdout . "\n";
            // echo serialize(["stdout", $stdout]);
        }

        // Read from stderr.
        if ($stderr = stream_get_contents($pipes[2])) {
            echo $stderr . "\n";
            // echo serialize(["stderr", $stderr]);
        }

        // Sleep for 0.1 seconds before checking again.
        usleep(100000);

        // Exit the loop if the process is no longer running.
        if (!$info["running"]) {
            break;
        }
    }

    // Close the pipes.
    fclose($pipes[1]);
    fclose($pipes[2]);

    return proc_close($process);
}

// If the process did not create a resource, then it failed to execute
// and we should report back to KinoPHP that the script failed.
return 1;
