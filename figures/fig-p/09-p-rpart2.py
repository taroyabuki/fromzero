import graphviz
import statsmodels.api as sm
from sklearn import tree
from sklearn.model_selection import GridSearchCV, LeaveOneOut

my_data = sm.datasets.get_rdataset('iris', 'datasets').data
X, y = my_data.iloc[:, 0:4], my_data.Species

my_params = {
    'max_depth': range(2, 6),
    'min_samples_split': [2, 20],
    'min_samples_leaf': range(1, 8)}

my_search = GridSearchCV(
    estimator=tree.DecisionTreeClassifier(min_impurity_decrease=0.01,
                                          random_state=0),
    param_grid=my_params,
    cv=LeaveOneOut(),
    n_jobs=-1).fit(X, y)

my_model = my_search.best_estimator_
my_dot = tree.export_graphviz(
    decision_tree=my_model,
    out_file=None,
    feature_names=X.columns,
    class_names=my_model.classes_,
    filled=True)
my_graph = graphviz.Source(my_dot)
my_graph.render('09-p-rpart2')
