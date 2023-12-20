<html>
<body>
    <div id="chat">
        <!-- メッセージ入力フォーム -->
        <textarea v-model="message"></textarea><br>
        <button type="button" @click="sendMessage">送信</button><br>

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

    <!-- axios は app.js に入っているので、とりあえず入れていたものは不要 -->
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.18.0/axios.min.js"></script> -->

    <!-- Viteでビルドしたファイルを読み込む -->
    @vite([
        'resources/js/app.js',
    ])

    <script type="module">
        import { createApp, ref, onMounted } from 'vue';

        createApp({
            setup() {
                const message = ref('');
                const messages = ref([]);

                onMounted(() => {
                    getMessages();

                    // 追加（通知のリスナーを設置）
                    Echo.channel('chat-test')
                    .listen('MessageCreated', (e) => {
                        console.log(e);
                        getMessages();
                    });
                });

                const sendMessage = () => {
                    axios.post('/ajax/message', {
                        'message': message.value,
                    }).then((res) => {
                        // メッセージをクリアする
                        message.value = '';
                    });
                };

                // 追加（メッセージ一覧を取得して表示する）
                const getMessages = () => {
                    axios.get('/ajax/messages')
                    .then((res) => {
                        // メッセージ一覧をセットする
                        messages.value = res.data;
                    });
                };

                return {
                    message,
                    messages,
                    sendMessage,    // 追加
                    getMessages,    // 追加
                };
            },
        }).mount('#chat');

    </script>
</body>
</html>