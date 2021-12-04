import graphviz
import statsmodels.api as sm
from sklearn import tree

my_data = sm.datasets.get_rdataset('iris', 'datasets').data
X, y = my_data.iloc[:, 0:4], my_data.Species

my_model = tree.DecisionTreeClassifier(max_depth=2, random_state=0)
my_model.fit(X, y)

my_dot = tree.export_graphviz(decision_tree=my_model,
                              out_file=None,
                              feature_names=X.columns,
                              class_names=my_model.classes_,
                              filled=True)
my_graph = graphviz.Source(my_dot)
my_graph.render('09-p-rpart')
