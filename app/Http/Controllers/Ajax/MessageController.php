<?php

namespace App\Http\Controllers\Ajax;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class MessageController extends Controller
{
    // メッセージをチャットメッセージDBテーブルに登録する
    public function setMessage(Request $request) {
        \App\Models\ChatMessage::create([
            'body' => $request->message,
        ]);

        // ********** イベント発火 **********
        event(new \App\Events\MessageCreated($request->message));
    }

    // メッセージ一覧を返す
    public function getMessages() {
        return \App\Models\ChatMessage::orderBy('id', 'desc')->get();
    }
}
