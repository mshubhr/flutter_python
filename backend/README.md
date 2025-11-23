# Backend (Flask) - to_do_flutter_python/backend

Quick start (Windows CMD):

1. Create and activate a virtual environment

```
python -m venv venv
venv\Scripts\activate
```

2. Install dependencies

```
pip install -r requirements.txt
```

3. Run the server (development)

```
python app.py
```

The server will create a SQLite database file `tasks.db` automatically on first run. Endpoints:

- `GET /tasks` - list tasks/profiles
- `POST /tasks` - create task/profile (JSON `{ "title": "Name" }`)
- `DELETE /tasks/<id>` - delete
- `POST /signup` - register `{ "username": "u", "password": "p" }`
- `POST /login` - login `{ "username": "u", "password": "p" }`

Notes:
- This setup is intended for local development. For production use a proper WSGI server, migrations (Flask-Migrate/Alembic), and secure configuration.
- Consider returning tokens (JWT) from `/login` and using HTTPS.
