import graphviz
import pandas as pd
from sklearn import tree
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder

my_url = ('https://raw.githubusercontent.com'
          '/taroyabuki/fromzero/master/data/titanic.csv')
my_data = pd.read_csv(my_url)

X, y = my_data.iloc[:, 0:3], my_data.Survived

my_pipeline = Pipeline([
    ('ohe', OneHotEncoder(drop='first')),
    ('tree', tree.DecisionTreeClassifier(max_depth=2, random_state=0,
                                         min_impurity_decrease=0.01))])
my_pipeline.fit(X, y)

my_enc  = my_pipeline.named_steps['ohe']
my_tree = my_pipeline.named_steps['tree']

my_dot = tree.export_graphviz(
    decision_tree=my_tree,
    out_file=None,
    feature_names=my_enc.get_feature_names(),
    class_names=my_pipeline.classes_,
    filled=True)
graphviz.Source(my_dot)
my_graph = graphviz.Source(my_dot)
my_graph.render('10-p-titanic-tree')
