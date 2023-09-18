ligo_compiler?=docker run --rm -v "$(PWD)":"$(PWD)" -w "$(PWD)" ligolang/ligo:0.57.0
# ^ Override this variable when you run make command by make <COMMAND> ligo_compiler=<LIGO_EXECUTABLE>
# ^ Otherwise use default one (you'll need docker)
protocol_opt?=
JSON_OPT?=--michelson-format json
tsc=npx tsc
help:
	@echo  'Usage:'
	@echo  '  all             - Remove generated Michelson files, recompile smart contracts and lauch all tests'
	@echo  '  clean           - Remove generated Michelson files'
	@echo  '  compile         - Compiles smart contract Random'
	@echo  '  test            - Run integration tests (written in Ligo)'
	@echo  '  deploy          - Deploy smart contract Random (typescript using Taquito)'
	@echo  ''

all: clean compile test

compile: random

random: random.tz random.json

random.tz: src/main.jsligo
	@if [ ! -d ./compiled ]; then mkdir ./compiled ; fi
	@echo "Compiling smart contract to Michelson"
	@$(ligo_compiler) compile contract $^  $(protocol_opt) > compiled/$@

random.json: src/main.jsligo
	@if [ ! -d ./compiled ]; then mkdir ./compiled ; fi
	@echo "Compiling smart contract to Michelson in JSON format"
	@$(ligo_compiler) compile contract $^ $(JSON_OPT)  $(protocol_opt) > compiled/$@

clean:
	@echo "Removing Michelson files"
	@rm -f compiled/*.tz compiled/*.json

test: test_ligo test_ligo_bytes

test_ligo: test/test.jsligo
	@echo "Running integration tests"
	@$(ligo_compiler) run test $^ $(protocol_opt)

test_ligo_bytes: test/test_bytes.jsligo
	@echo "Running integration tests (bytes conversion)"
	@$(ligo_compiler) run test $^ $(protocol_opt)

deploy: node_modules deploy.js

deploy.js:
	@if [ ! -f ./deploy/metadata.json ]; then cp deploy/metadata.json.dist deploy/metadata.json ; fi
	@echo "Running deploy script\n"
	@cd deploy && npm start

node_modules:
	@echo "Installing deploy script dependencies"
	@cd deploy && npm install
	@echo ""
