## 正誤表

場所|誤|正
--|--|--
p. 56 最初のコード（R）|`0.3333333`|`3.333333`
p. 56 最初のコード（Python）|`0.3333333333333333`|`3.3333333333333335`
p. 56 脚註1|0.3333333|3.333333
p. 119 脚註9|[4.3, 4.7, 5.1, 5.5, 5.9, 6.300000000000001, 6.7, 7.1000000000000005, 7.5, 7.9]です．小さな誤差が，観測値6.3や7.1が属する階級に影響し，このままではヒストグラムがRと同じになりません．同じにするために，ここでは`round`で数値を丸めています．|[4.3, 4.7, 5.1, 5.5, 5.9, 6.3, 6.7, 7.1, 7.5, 7.9]から少しずれます．Rではこの結果を丸めてから数を数えます．それと同じにするために，ここでは`round`で数値を丸めています．
p. 184 脚註4|回帰直線|予測値の期待値
p. 194 Pythonのコード（2箇所）|`PolynomialFeatures(d)`|`PolynomialFeatures(d, include_bias=False)`
p. 233 旁註|`sc`や`lm`|`sc`や`lr`
p. 233 旁註|`my_model.named_steps.lm`|`my_pipeline.named_steps.lr`
p. 240 旁註|`sfs`と`lm`|`sfs`と`lr`
p. 272 下から2行目|Sepal.With|Sepal.Width
p. 341 脚註5|`autoplot(level = c(80, 90))`|`autoplot(level = c(80, 95))`
p. 349 本文上から3行目|描かれいます|描かれています

## 補足

- Amazon SageMaker Studio Labでの動作を確認しました（[解説](addendum/sagemaker)）．
- [7.3.2 予測値の期待値の信頼区間](addendum/07.03.02/)
- [7.4.3 当てはまりの良さの指標の問題点](addendum/07.04.03.ipynb)
- 8.6.3項のPythonのコードで警告がたくさん出る場合は，事前に`warnings.simplefilter('ignore')`を実行してみてください．「`n_jobs=-1`」としていると効果がないという[報告](https://stackoverflow.com/a/55595680)もありますが．
- 9.4.2, 9.5.3項のPythonのコードで警告がたくさん出る場合は，`warnings.simplefilter`の引数の「`, UserWarning`」を削除してみてください．配布しているコードはそのように修正しています．
- 9.6.2項のPythonのコードで警告がたくさん出る場合は，`MLPClassifier()`を`MLPClassifier(max_iter=1000)`に変更してみてください．配布しているコードはそのように修正しています．
