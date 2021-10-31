<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Media extends Model
{
    public static function files($limit, $start)
    {
        $path = public_path().'/uploads';
        $files = scandir($path);

        $allfiles = array();
        $i=0;
        foreach ($files as $file) {
            // check is file or not
            if(is_file($path.'/'.$file)){
                $allfiles[$i]['file'] = $file;
                $i++;
            }
        }

        return [
            "data" => array_slice($allfiles, $start, $limit),
            "count" => count($files)
        ];
    }
}
