# 更新情報・正誤表

公開しているコードでは，以下の内容を反映しています．

## 更新情報

場所|説明
--|--
p. 6|Windows 11には，脚註4で紹介しているWindows Terminalが搭載されています．
p. 20|[Amazon SageMaker Studio Lab](addendum/sagemaker)での動作も確認済みです．表2.1のクラウド・ノートブックに相当します．
p. 22 脚註3|Google Colabでノートブックを新規作成した後で，ランタイム→ランタイムのタイプを変更で，Rを選択できるようになりました．
p. 56|Rのコード`左辺 %<-% 右辺`が正しく動作しない場合は，``keras::`%<-%`(左辺, 右辺)``に変更してください．
p. 151|GitHub上でのCSVファイルの表示方法が変更されたので，https://github.com/taroyabuki/fromzero/blob/master/data/exam.csv の代わりにhttps://taroyabuki.github.io/fromzero/exam.html を使ってください．
p. 160, 161|scikit-learnのバージョンによっては，Pythonのコードの`get_feature_names()`を`get_feature_names_out()`に変更する必要があります．
p. 184|[予測値の期待値の信頼区間](addendum/07.03.02/)
p. 194|[「7.4.3 当てはまりの良さの指標の問題点」についての補足](addendum/07.04.03.ipynb)
p. 271, 275|XGBoostで`ValueError: Invalid classes inferred from unique values of y. Expected: [0 1 2], got ['setosa' 'versicolor' 'virginica']`というエラーが出る場合は，`LabelEncoder`を使ってラベルを数値に変換してください．
p. 271, 275|9.4.2, 9.5.3項のPythonのコードで警告がたくさん出る場合は，`warnings.simplefilter`の引数の「`, UserWarning`」を削除してみてください．
p. 277|9.6.2項のPythonのコードで警告がたくさん出る場合は，`MLPClassifier()`を`MLPClassifier(max_iter=1000)`に変更してみてください．
p. 292, 298|scikit-learnのバージョンによっては，Pythonのコードの`get_feature_names()`を`get_feature_names_out()`に変更する必要があります．
p. 310, 329|Rのコード`左辺 %<-% 右辺`が正しく動作しない場合は，``keras::`%<-%`(左辺, 右辺)``に変更してください．
p. 342|Pythonのコードの`from fbprophet import Prophet`を`from prophet import Prophet`に変更する必要がある場合があります．

## 正誤表

場所|誤|正
--|--|--
p. 138 本文1行目|確率（約0.22）|確率（約0.022）

次の誤りは第5刷で修正しました．

場所|誤|正
--|--|--
p. 258 本文3行目|グラフの中で|連結グラフ（任意の2点を線をつないで結べるグラフ）の中で
p. 351 Pythonのコード|`vals, vecs = np.linalg.eig(S)   # 固有値と固有ベクトル`|`vals, vecs = np.linalg.eig(S)   # 固有値と固有ベクトル`<br>`idx = np.argsort(-vals)              # 固有値の大きい順の番号`<br>`vals, vecs = vals[idx], vecs[:, idx] # 固有値の大きい順での並べ替え`

次の誤りは第4刷で修正しました．

場所|誤|正
--|--|--
p. 56 最初のコード（R）|`0.3333333`|`3.333333`
p. 56 最初のコード（Python）|`0.3333333333333333`|`3.3333333333333335`
p. 56 脚註1|0.3333333|3.333333
p. 119 脚註9|[4.3, 4.7, 5.1, 5.5, 5.9, 6.300000000000001, 6.7, 7.1000000000000005, 7.5, 7.9]です．小さな誤差が，観測値6.3や7.1が属する階級に影響し，このままではヒストグラムがRと同じになりません．同じにするために，ここでは，`round`で誤差を消しています．|[4.3, 4.7, 5.1, 5.5, 5.9, 6.3, 6.7, 7.1, 7.5, 7.9]から少しずれます．Rも同様なのですが，Rではそのずれを丸めて消してから数を数えます．ここでは，Pythonでもそうなるように，`round`で数値を丸めています．
p. 184 脚註4|回帰直線|予測値の期待値
p. 194 Pythonのコード（2箇所）|`PolynomialFeatures(d)`|`PolynomialFeatures(d, include_bias=False)`
p. 233 旁註|`sc`や`lm`|`sc`や`lr`
p. 233 旁註|`my_model.named_steps.lm`|`my_pipeline.named_steps.lr`
p. 240 旁註|`sfs`と`lm`|`sfs`と`lr`
p. 272 下から2行目|Sepal.With|Sepal.Width
p. 341 脚註5|`autoplot(level = c(80, 90))`|`autoplot(level = c(80, 95))`
p. 349 本文上から3行目|描かれいます|描かれています
