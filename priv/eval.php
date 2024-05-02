<?php

require __DIR__ . "/boot_composer.php";
require __DIR__ . "/boot_laravel.php";

// Before the script is being evaluated, retrieve all of the defined
// variables. These are used to check which variables were declared
// during the evaluation.
$vars_before = array_keys(get_defined_vars());
$vars_before[] = "vars_before";

// Evaluate the script.
eval($argv[1]);

// Now, find the variables that were declared during the evaluation
// and prepare them to be sent to elixir.
$vars_defined = array_diff(
    array_keys(get_defined_vars()),
    $vars_before
);

var_export($vars_defined);
