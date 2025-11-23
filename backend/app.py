from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt

app = Flask(__name__)
CORS(app)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///tasks.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
bcrypt = Bcrypt(app)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(90), unique=True, nullable=False)
    password_hash = db.Column(db.String(129), nullable=False)

    def set_password(self, password: str):
        self.password_hash = bcrypt.generate_password_hash(password).decode('utf-8')

    def check_password(self, password: str) -> bool:
        return bcrypt.check_password_hash(self.password_hash, password)

class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)

@app.route("/tasks", methods=["GET"])
def get_tasks():
    try:
        tasks = [{"id": t.id, "title": t.title} for t in Task.query.order_by(Task.id.desc()).all()]
        return jsonify(tasks), 200
    except Exception as e:
        return jsonify({"error": "Failed to fetch tasks"}), 500

@app.route("/tasks", methods=["POST"])
def add_task():
    data = request.get_json() or {}
    title = data.get("title", "Untitled").strip()
    if not title:
        return jsonify({"error": "Title cannot be empty"}), 400
    try:
        new_task = Task(title=title)
        db.session.add(new_task)
        db.session.commit()
        return jsonify({"id": new_task.id, "title": new_task.title}), 201
    except Exception:
        db.session.rollback()
        return jsonify({"error": "Failed to create task"}), 500

@app.route("/tasks/<int:task_id>", methods=["DELETE"])
def delete_task(task_id):
    try:
        task = Task.query.get(task_id)
        if task:
            db.session.delete(task)
            db.session.commit()
            return '', 204
        return jsonify({"error": "Task not found"}), 404
    except Exception:
        db.session.rollback()
        return jsonify({"error": "Failed to delete task"}), 500

@app.route("/signup", methods=["POST"])
def signup():
    data = request.get_json() or {}
    username = (data.get("username") or "").strip()
    password = data.get("password") or ""

    if not username or not password:
        return jsonify({"error": "Username and password are required"}), 400

    if User.query.filter_by(username=username).first():
        return jsonify({"error": "Username already exists"}), 400

    try:
        new_user = User(username=username)
        new_user.set_password(password)
        db.session.add(new_user)
        db.session.commit()
        return jsonify({"message": "Signup successful", "user": {"id": new_user.id, "username": new_user.username}}), 201
    except Exception:
        db.session.rollback()
        return jsonify({"error": "Failed to create user"}), 500

@app.route("/login", methods=["POST"])
def login():
    data = request.get_json() or {}
    username = (data.get("username") or "").strip()
    password = data.get("password") or ""

    if not username or not password:
        return jsonify({"error": "Username and password are required"}), 400

    user = User.query.filter_by(username=username).first()
    if user and user.check_password(password):
        # NOTE: for production return a JWT or session token instead
        return jsonify({"message": "Login successful", "user": {"id": user.id, "username": user.username}}), 200
    return jsonify({"error": "Invalid credentials"}), 401

if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(host="0.0.0.0", port=5000, debug=True)