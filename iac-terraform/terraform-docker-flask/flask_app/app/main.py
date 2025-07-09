from flask import Flask, render_template
from db import get_db_version, create_table, insert_data, view_data, delete_table

app = Flask(__name__)

@app.route('/')
def home():
    message = get_db_version()
    return render_template('home.html', message=message)

@app.route('/create_table')
def create_table_route():
    message = create_table()
    return render_template('message.html', message=message)

@app.route('/insert_data')
def insert_data_route():
    message = insert_data()
    return render_template('message.html', message=message)

@app.route('/view_data')
def view_data_route():
    data = view_data()
    # view_data() returns either an error string or a list of rows
    # Let's refactor db.py's view_data() to return data in list format
    if isinstance(data, str):
        # error message or "No data"
        return render_template('message.html', message=data)
    else:
        return render_template('view_data.html', employees=data)

@app.route('/delete_table')
def delete_table_route():
    message = delete_table()
    return render_template('message.html', message=message)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
