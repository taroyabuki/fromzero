## 正誤表

場所|誤|正
--|--|--
p. 56 最初のコード（R）|`0.3333333`|`3.333333`
p. 56 最初のコード（Python）|`0.3333333333333333`|`3.3333333333333335`
p. 56 脚註1|0.3333333|3.333333
p. 194 最初のコード|`X5 = PolynomialFeatures(d).fit_transform(X)`|`X5 = PolynomialFeatures(d, include_bias=False).fit_transform(X)`

## 補足

[7.4.3 当てはまりの良さの指標の問題点](addendum/07.04.03.ipynb)