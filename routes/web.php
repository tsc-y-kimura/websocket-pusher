<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

// チャット画面表示のルーティング
Route::get('/chat', \App\Http\Controllers\ChatController::class);

// Ajax メッセージ登録
Route::post('/ajax/message', [\App\Http\Controllers\Ajax\MessageController::class, 'setMessage']);
// Ajax メッセージ一覧取得
Route::get('/ajax/messages', [\App\Http\Controllers\Ajax\MessageController::class, 'getMessages']);
