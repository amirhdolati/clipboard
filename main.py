from flask import Flask, redirect, render_template
from flask_restful import Resource, Api, request
import pickle



# create flask and api instance
app = Flask("clipboard-server")
api = Api(app)

# flask config begins
app.jinja_env.auto_reload = True
app.config['TEMPLATES_AUTO_RELOAD'] = True
# flask config ends


# text feild and db management functions
text_field = ""
DB_NAME = "db.pickle"
def init_db():
    try:
        global text_field
        with open(DB_NAME, "rb") as f:
           text_field = pickle.load(f)
    except FileNotFoundError:
        with open(DB_NAME, "wb") as f:
            pickle.dump(text_field, f)
    except:
        print("something wrong for read/write in " + DB_NAME) 

def save_text_field():
    global text_field
    try:
        with open(DB_NAME, "wb") as f:
            pickle.dump(text_field, f)
    except:
        print("something wrong for write in " + DB_NAME) 


# restful api function
class clipboard_api(Resource):
    def get(self):
        return{'text_field':text_field}
    def post(self):
        global text_field
        text_field = request.get_json(force=True)['text_field']
        save_text_field()
        return redirect("/", code=302)


# register clipboard_api endpoint
api.add_resource(clipboard_api, '/api')

# register root endpoint and clipboard_root function
@app.route('/')
def clipboard_root():
    return render_template("root.html", text_field=text_field)

# load database
init_db()

# run flask server
app.run(debug=False)