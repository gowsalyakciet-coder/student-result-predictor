import pandas as pd
from sklearn.tree import DecisionTreeClassifier
import joblib

data = pd.DataFrame({
    "study_hours": [1, 2, 3, 4, 5, 6, 7, 8, 2, 5],
    "attendance": [40, 50, 60, 70, 80, 85, 90, 95, 45, 75],
    "internal_marks": [10, 20, 30, 40, 60, 70, 80, 90, 15, 55],
    "result": ["Fail", "Fail", "Fail", "Fail", "Pass",
               "Pass", "Pass", "Pass", "Fail", "Pass"]
})

X = data[["study_hours", "attendance", "internal_marks"]]
y = data["result"]

model = DecisionTreeClassifier(random_state=42)
model.fit(X, y)

joblib.dump(model, "model.pkl")

print("Model trained and saved successfully!")