#!flask/bin/python

from flask import Flask, abort

from myapp import dosomething

application = Flask(__name__)


@application.route('/', methods=['POST'])
def run_calculation():
    try:
        dosomething.print_it("I'm doing something!")
        return 'SUCCESS', 200
    except:
        abort(400)
