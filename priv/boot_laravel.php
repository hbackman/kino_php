<?php

define('LARAVEL_START', microtime(true));

function get_laravel_dir($path)
{
    if ($path == "/") {
        return null;
    }

    if (is_readable("$path/bootstrap/app.php")) {
        return "$path";
    }

    return get_laravel_dir(dirname($path));
}

$laravel_dir = get_laravel_dir(getcwd());

if (! $laravel_dir) {
    return;
}

$app = require_once "$laravel_dir/bootstrap/app.php";

$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);

$kernel->bootstrap();

// Register a shutdown function so that when the smart cell is done, laravel can
// fire off the shutdown events so that any final work may be done before we shut
// down the process.
register_shutdown_function(function () use ($kernel) {
    $kernel->terminate(new \Symfony\Component\Console\Input\ArrayInput([]), 0);
});