<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ChatMessagesTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // ダミーデータをセットする
        for ($i = 0; $i < 10; $i++) {
            \App\Models\ChatMessage::create([
                'body' => $i.'番目のメッセージ',
            ]);
        }
        
    }
}
