ifeq ("$(SETTINGS)", "")
	ifeq ("$(wildcard ./config/live.cfg)", "")
		SETTINGS=./config/development.cfg
	else
		SETTINGS=./config/live.cfg
	endif
endif

ifeq ("$(TEST_SETTINGS)", "")
	TEST_SETTINGS=./config/test.cfg
endif

.PHONY: run update outdated listdepends clean

run:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./dev_server.py

update:
	PIPENV_MAX_SUBPROCESS=$$(($$(nproc)+1)) pipenv sync --dev

deploy:
	PIPENV_MAX_SUBPROCESS=$$(($$(nproc)+1)) pipenv install --deploy

lock:
	pipenv lock

clean:
	rm -rf ./__pycache__  # In theory pycache should be version dependent
	rm -rf ./lib          # & this shouldn't exist any more
	rm -rf ./env


db:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py db upgrade

migrate:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py db migrate -m '$(msg)'

data: db perms tickets bankaccounts importvenues

dev-data: volunteerdata volunteershifts fakedata

exportdb:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py exportdb

perms:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py createperms

tickets:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py createtickets

bankaccounts:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py createbankaccounts

loadofx:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py loadofx -f var/data.ofx
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py loadofx -f var/data-eur.ofx

checkreconcile:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py reconcile

reallyreconcile:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py reconcile -d

cancelreservedtickets:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py cancelreservedtickets

pyppeteer:
	sudo -u www-data pipenv run ./pyppeteer-launcher.py

sendtickets:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py sendtickets

fakedata:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py makefakedata

volunteerdata:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py makevolunteerdata

volunteershifts:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py makevolunteershifts

shiftsfromproposals:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py makeshiftsfromproposals

lockproposals:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py lockproposals

importcfp:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py importcfp

emailspeakersaboutslot:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py emailspeakersaboutslot

emailspeakersaboutfinalising:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py emailspeakersaboutfinalising

emailspeakersaboutreservelist:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py emailspeakersaboutreservelist

importvenues:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py importvenues

setroughdurations:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py setroughdurations

runscheduler:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py runscheduler -p

applypotentialschedule:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py applypotentialschedule

shell:
	SETTINGS_FILE=$(SETTINGS) PYTHONPATH=. FLASK_APP=wsgi pipenv run flask shell

sendemails:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py sendemails

admin:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py makeadmin ${ARGS}

arrivals:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py makearrivals

calendars:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py createcalendars

refreshcalendars:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py refreshcalendars

exportcalendars:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py exportcalendars

parkingtickets:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py createparkingtickets

matchyoutube:
	SETTINGS_FILE=$(SETTINGS) pipenv run python ./utils.py matchyoutube

test:
	SETTINGS_FILE=$(TEST_SETTINGS) pipenv run flake8 ./*.py ./models ./apps ./tasks ./utils.py
	SETTINGS_FILE=$(TEST_SETTINGS) pipenv run pytest ./tests/ ./models/

testdb:
	SETTINGS_FILE=$(TEST_SETTINGS) pipenv run python ./utils.py db upgrade

