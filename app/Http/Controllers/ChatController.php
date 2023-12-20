<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ChatController extends Controller
{
    // チャット画面の表示
    public function __invoke() {
        return view('chat');
    }

}
