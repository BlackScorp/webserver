<?php
if (extension_loaded('xhprof')) {
    $profiler_namespace = $_SERVER['SCRIPT_FILENAME'];  // namespace for your application
    $xhprof_data = xhprof_disable();
    $xhprof_runs = new XHProfRuns_Default();
    $run_id = $xhprof_runs->save_run($xhprof_data, $profiler_namespace);
 
    // url to the XHProf UI libraries (change the host name and path)
    $profiler_url = sprintf('http://%s/xhprof/index.php?run=%s&amp;source=%s',$_SERVER['SERVER_ADDR'], $run_id, $profiler_namespace);
    echo '<a href="'. $profiler_url .'" target="_blank">Profiler output</a>';
}
?>