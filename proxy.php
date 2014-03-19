<?php

$filename = $_GET['url'];
$ext = pathinfo($filename, PATHINFO_EXTENSION);

switch ($ext) {
    case "jpg":
        header('Content-Type: image/jpeg');
        readfile($filename);
        break;
    case "gif":
        header('Content-Type: image/gif');
        readfile($filename);
        break;
    case "png":
        header('Content-Type: image/png');
        readfile($filename);
        break;
	case "json":
        header('Content-Type: text/json');
        $json = $filename;
       readfile($json);
        break;
    case "xml":
        header('Content-Type: text/xml');
        $xml = $filename;
       readfile($xml);
        break;
}
?>