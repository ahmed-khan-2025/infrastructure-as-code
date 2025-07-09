import os
import psycopg2
from psycopg2.extras import RealDictCursor

def get_db_connection():
    return psycopg2.connect(
        host=os.getenv("POSTGRES_HOST"),
        dbname=os.getenv("POSTGRES_DB"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
        cursor_factory=RealDictCursor
    )

def get_db_version():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT version();")
        version = cur.fetchone()
        cur.close()
        conn.close()
        return version['version']
    except Exception as e:
        return f"Error: {str(e)}"

def create_table():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            CREATE TABLE IF NOT EXISTS employees (
                id SERIAL PRIMARY KEY,
                name VARCHAR(100),
                position VARCHAR(100),
                salary NUMERIC
            );
        """)
        conn.commit()
        cur.close()
        conn.close()
        return "Table 'employees' created successfully."
    except Exception as e:
        return f"Error: {str(e)}"

def insert_data():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO employees (name, position, salary) VALUES
            ('Alice', 'Manager', 90000),
            ('Bob', 'Developer', 80000),
            ('Charlie', 'Designer', 70000);
        """)
        conn.commit()
        cur.close()
        conn.close()
        return "Sample data inserted successfully."
    except Exception as e:
        return f"Error: {str(e)}"

def view_data():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT id, name, position, salary FROM employees;")
        rows = cur.fetchall()
        cur.close()
        conn.close()
        if rows:
            return rows
        else:
            return "No data found."
    except Exception as e:
        return f"Error: {str(e)}"

def delete_table():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("DROP TABLE IF EXISTS employees;")
        conn.commit()
        cur.close()
        conn.close()
        return "Table 'employees' deleted successfully."
    except Exception as e:
        return f"Error: {str(e)}"
