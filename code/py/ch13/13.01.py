## 13.1 主成分分析

import numpy as np
import pandas as pd
from pca import pca
from scipy.stats import zscore

my_data = pd.DataFrame(
    {'language': [  0,  20,  20,  25,  22,  17],
     'english':  [  0,  20,  40,  20,  24,  18],
     'math':     [100,  20,   5,  30,  17,  25],
     'science':  [  0,  20,   5,  25,  16,  23],
     'society':  [  0,  20,  30,   0,  21,  17]},
    index=       ['A', 'B', 'C', 'D', 'E', 'F'])
my_model = pca(n_components=5)
my_result = my_model.fit_transform(my_data) # 主成分分析の実行

my_result['PC'] # 主成分スコア
#>          PC1        PC2 ...
#> A  74.907282   7.010808 ...
#> B -13.818842  -2.753459 ...
#> C -33.714034  18.417290 ...
#> D  -1.730630 -17.876372 ...
#> E -17.837474   1.064998 ...
#> F  -7.806303  -5.863266 ...

my_model.biplot(legend=False)

my_result['loadings']
#>      language   english      math   science   society
#> PC1 -0.207498 -0.304360  0.887261 -0.130198 -0.245204
#> PC2 -0.279463  0.325052  0.097643 -0.702667  0.559435
#> PC3  0.306117  0.615799  0.056345 -0.338446 -0.639815
#> PC4  0.764943 -0.471697 -0.007655 -0.418045  0.132455
#> PC5 -0.447214 -0.447214 -0.447214 -0.447214 -0.447214

my_result['explained_var']
#> array([0.88848331, 0.97962854, 0.99858005, 1.        , 1.        ])

### 13.1.1 標準化＋主成分分析

tmp = zscore(my_data, ddof=1) # 標準化
my_result = my_model.fit_transform(
    tmp)
my_result['PC'] # 主成分スコア
#>           PC1       PC2 ...
#> 1.0  3.673722  0.568850 ...
#> 1.0 -0.652879 -0.246926 ...
#> 1.0 -1.568294  1.742598 ...
#> 1.0 -0.250504 -1.640039 ...
#> 1.0 -0.886186  0.110493 ...
#> 1.0 -0.315858 -0.534976 ...

### 13.1.2 補足：行列計算による再現

tmp = my_data - my_data.mean()
Z  = np.matrix(tmp)                       # 標準化しない場合
#Z = np.matrix(tmp / my_data.std(ddof=1)) # √不偏分散で標準化する場合
#Z = np.matrix(tmp / my_data.std(ddof=0)) # pca(normalize=True)に合わせる場合

n = len(my_data)
S = np.cov(Z, rowvar=0, ddof=0) # 分散共分散行列
#S = Z.T @ Z / n                # （同じ結果）
vals, vecs = np.linalg.eig(S)   # 固有値と固有ベクトル
idx = np.argsort(vals)[::-1]         # 固有値の大きい順の番号
vals, vecs = vals[idx], vecs[:, idx] # 固有値の大きい順での並べ替え
Z @ vecs                        # 主成分スコア（結果は割愛）
vals.cumsum() / vals.sum()      # 累積寄与率
#> array([0.88848331, 0.97962854, 0.99858005, 1.        , 1.        ])

U, d, V =  np.linalg.svd(Z, full_matrices=False)     # 特異値分解
W = np.diag(d)

[np.isclose(Z, U @ W @ V).all(),                     # 確認1
 np.isclose(U.T @ U, np.identity(U.shape[1])).all(), # 確認2
 np.isclose(V @ V.T, np.identity(V.shape[0])).all()] # 確認3
#> [True, True, True]

U @ W                # 主成分スコア（結果は割愛）

e = d ** 2 / n       # 分散共分散行列の固有値
e.cumsum() / e.sum() # 累積寄与率
#> array([0.88848331, 0.97962854, 0.99858005, 1.        , 1.        ])
