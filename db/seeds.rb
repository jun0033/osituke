# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
p '==================== admin create ===================='
Admin.create!(email: "admin@gmail.com", password: "000000")
p '==================== user create ===================='
User.create!(name: "junya", email: "junya@gmail.com", password: "jjjjjj")
User.create!(name: "しゅみー", email: "shumii@gmail.com", password: "ssssss")
User.create!(name: "flamingo", email: "flamingo@gmail.com", password: "ffffff")
User.create!(name: "押し付けタロウ", email: "osituke@gmail.com", password: "oooooo")
User.create!(name: "エリザベス", email: "elizabeth@gmail.com", password: "eeeeee")
p '==================== genre create ===================='
Genre.create!(genre_name: "スポーツ")
Genre.create!(genre_name: "手芸")
Genre.create!(genre_name: "アウトドア")
Genre.create!(genre_name: "オリジナル")
Genre.create!(genre_name: "音楽")
Genre.create!(genre_name: "ゲーム")
p '==================== hobby create ===================='
Hobby.create!(user_id: 1,genre_id: 1,title: "サイクリング",
body: "朝４時に起きて自転車に乗り、誰もいない町を走るとさいっこーに気持ちいいんだ！君もよかったら一緒に走らない？",)
Hobby.create!(user_id: 2,genre_id: 2,title: "コイン磨き",
body: "自分のお財布に入ってるコインをお酢に浸して磨くとキラッキラになるの。あなたもやってみて！自分のお金は特別って感じがするわよ。")
Hobby.create!(user_id: 3,genre_id: 3,title: "キャンプ",
body: "キャンプって聞いてハードル高いと思ったよな？でも待ってくれ。手ぶらキャンプというものがあって用意するものは何もないんだ。大自然と向き合って過ごすだけで解放感あるからぜひ一回だけでもやってみてほしい。")
Hobby.create!(user_id: 4,genre_id: 4,title: "イエスマン",
body: "自分の中で時間を決めてその間イエスマンになるんだ。その時間は誰にも言わないで、周りに言われたことをすべて受け入れる。全てにYESと答えるんだ。ドキドキするだろ？
このチャレンジを終えた後、君は周りからの信頼を欲しいままにしているだろう。")
Hobby.create!(user_id: 5,genre_id: 5,title: "足音リズム",
body: "音楽を聴きながら歩いているとリズムに合わせて足が動いてしまうことってあるでしょ？普通はそこで逆らって一定のリズムで歩こうとするわ。
でもこの趣味を始めたあなたは音楽のリズムに身を委ねるの。普段の通勤がずっと楽しくなるに違いないわ")