# アプリ概要

## 使い方

### 登録しましょう
TODO

### 相手を招待しましょう
TODO

### 払った金額を入力しましょう
シンプルに、割り勘する金額を入力するだけです。誰かと二人で飲みに行って、お会計が6000円だとしましょう。
建て替えたほうが、記録画面に行き、6000円と入力するだけです。貸した金額として、3000円がプラスされます。

## 作成背景
お金を貸し借りするのって面倒ですよね。
毎回その場で割り勘するのは面倒だし、あとで返すにも、そのためにお金をおろしたりしなきゃいけなくて面倒。
パートナーと一緒に暮らしている人だと、特にその頻度は高いと思います。（ここは俺が払っとくよ。みたいに）
最近だとキャッシュレスの時代なので、アプリで送金できるよって方もいると思いますが、同じアプリを使ってないとそれも難しいです。

そんなとき、そもそもお金を返すのに、次は自分が払うよってしちゃえば面倒なこともないなと思ったのが、このアプリを作ったきっかけです。
お互いが払った金額を記録しておき、その差分によって、どちらが払うかを決めればよいのです。
なるべく差が開かないように保っておくと、関係がこじれずに済むと思います。
想定ユーザーとしては、お金のやりとりが多い、同棲しているカップルや、親友同士など。

## 技術スタック
Flutter, Firebase Authentication, Cloud Firestore
