<?php

define("LARAVEL_START", microtime(true));

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

if (!($laravel_dir = get_laravel_dir(getcwd()))) {
    define("KINO_PHP_LARAVEL", false);

    return;
} else {
    define("KINO_PHP_LARAVEL", true);
}

// Boot the application.

use Illuminate\Contracts\Console\Kernel;
use Symfony\Component\Console\Input\ArrayInput;

use Symfony\Component\VarDumper\Caster\ReflectionCaster;
use Symfony\Component\VarDumper\Cloner\VarCloner;
use Symfony\Component\VarDumper\Dumper\CliDumper;
use Symfony\Component\VarDumper\VarDumper;

$app = require_once "$laravel_dir/bootstrap/app.php";

$kernel = $app->make(Kernel::class);
$kernel->bootstrap();

// To make the output a little nicer, we can override the var dumper to support
// ANSI terminal colors.

$cloner = new VarCloner();
$cloner->addCasters(ReflectionCaster::UNSET_CLOSURE_FILE_INFO);

$dumper = new class extends CliDumper {
    /**
     * Always returns true.
     */
    protected function supportsColors(): bool
    {
        return true;
    }
};

VarDumper::setHandler(function ($var) use ($dumper, $cloner) {
    $dumper->dump($cloner->cloneVar($var));
});

// Register a shutdown function so that when the smart cell is done, laravel can
// fire off the shutdown events so that any final work may be done before we shut
// down the process.
register_shutdown_function(function () use ($kernel) {
    $kernel->terminate(new ArrayInput([]), 0);
});
