build:
	docker-compose build

build-nc:
	docker-compose build --no-cache

build-progress:
	docker-compose build --no-cache --progress=plain

down:
	docker-compose down --volumes

run:
	make down && docker-compose up

run-scaled:
	make down && docker-compose up --build --scale spark-worker=2

run-d:
	make down && docker-compose up -d

stop:
	docker-compose stop

submit:
	docker exec da-spark-master spark-submit --master spark://spark-master:7077 --deploy-mode client ./apps/$(app)

jupyter:
	jupyter lab --ip 0.0.0.0 --port 8888 --allow-root --no-browser

grafana:
	docker run -d --name=grafana -p 3000:3000 grafana/grafana