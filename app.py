from flask import Flask, request
import joblib
import pandas as pd

app = Flask(__name__)
model = joblib.load("model.pkl")

@app.route("/", methods=["GET", "POST"])
def home():
    result = ""

    if request.method == "POST":
        hours = float(request.form["hours"])
        attendance = float(request.form["attendance"])
        marks = float(request.form["marks"])

        data = pd.DataFrame(
            [[hours, attendance, marks]],
            columns=["study_hours", "attendance", "internal_marks"]
        )

        prediction = model.predict(data)[0]
        result = f"<h2>Prediction: {prediction}</h2>"

    return f"""
    <html>
    <head><title>Student Result Predictor</title></head>
    <body>
        <h1>Student Result Predictor</h1>
        <h3>Model Version: 1.0</h3>
        <form method="post">
            Study Hours:
            <input type="number" name="hours" min="0"
                   max="24" step="0.5" required><br><br>
            Attendance (%):
            <input type="number" name="attendance" min="0"
                   max="100" required><br><br>
            Internal Marks:
            <input type="number" name="marks" min="0"
                   max="100" required><br><br>
            <button type="submit">Predict Result</button>
        </form>
        {result}
    </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)