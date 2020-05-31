-include secrets.mk
venv:
	python3 -m virtualenv venv
	./venv/bin/pip install -r requirements.txt

systemd:
	PWD=$(pwd)
	envsubst < pihole-health.service > pihole-health.service_tmp
	sudo mv pihole-health.service_tmp /etc/systemd/system/pihole-health.service
	sudo cp pihole-health.timer /etc/systemd/system/
	systemctl stop pihole-health.service
	systemctl stop pihole-health.timer
	systemctl daemon-reload
	systemctl enable pihole-health.service
	systemctl enable pihole-health.timer

install: venv systemd

health-check:
	./venv/bin/python pihole-health.py \
		--pass-url ${pass_url} \
		--pihole-ip ${pihole_ip} \
		--test-domain ${test_domain} \
		--test-domain-ip ${test_domain_ip}

clean:
	rm -rf venv

