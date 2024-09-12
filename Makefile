
include .env
.PHONY: all
all: run

.PHONY: install
install:
	poetry install

install_pip:
	pip install -r requirements.txt

run:
	poetry run python ./ragas_entry_point.py

list_instances:
	sh ./scripts/cur_instances.sh
stop_instances:
	sh ./scripts/stop_instances.sh
kill_instances:
	sh ./scripts/kill_instances.sh 
start_and_sync:
	sh ./scripts/start_and_sync.sh
create_new_instance:
	sh ./scripts/create_new_instance.sh
sync:
	sh ./scripts/simply_sync.sh
watch:
	sh ./scripts/watch_files.sh $(INST) $(ZONE)
docker:
	docker buildx build -t $(NAME):$(TAG) .

clean:
	# TODO: 
	echo "TODO: not yet implemented"
