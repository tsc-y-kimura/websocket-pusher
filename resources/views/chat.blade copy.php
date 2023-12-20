<html>
<body>
    <div id="chat">
        <!-- メッセージ入力フォーム -->
        <textarea v-model="message"></textarea><br>
        <button type="button" @click="send">送信</button><br>

        <!-- メッセージ一覧表示 -->
        <div v-for="m in messages">
            【<span v-text="m.created_at"></span>】<span v-text="m.body"></span>
        </div>
    </div>

    <!-- Vue3ライブラリ（CDN）の読み込み -->
    <script type="importmap">
        {
            "imports": {
                "vue": "https://cdn.jsdelivr.net/npm/vue@3.2/dist/vue.esm-browser.js"
            }
        }
    </script>

    

    <script type="module">
        import { createApp, ref, onMounted } from 'vue';

        createApp({
            setup() {
                const message = ref('');
                const messages = ref([]);

                onMounted(() => {
                    // メッセージ一覧更新処理
                    getMessages();

                    // Pusher からの通知を待機するリスナー
                    Echo.channel('chat')
                    .listen('MessageCreated', (e) => {
                        // メッセージ一覧更新処理
                        getMessages();
                    });
                });

                // メッセージを送ってサーバーDBに保存する処理
                const send = () => {
                    axios.post('/ajax/chat', {
                        message: message.value,
                    }).then((res) => {
                        // メッセージをクリア
                        message.value = '';
                    });
                };

                // メッセージ一覧をサーバーDBから取得して表示する処理
                const getMessages = () => {
                    axios.get('/ajax/chat')
                    .then((res) => {
                        messages.value = res.data;
                    });
                };

                return {
                    message,
                    messages,
                    send,
                    getMessages,
                };
            },
        }).mount('#chat');

    </script>
</body>
</html>