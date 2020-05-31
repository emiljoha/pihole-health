-include secrets.mk
venv:
	python3 -m virtualenv venv
	./venv/bin/pip install -r requirements.txt

systemd:
	PWD=$(pwd)
	envsubst < pihole-health.service > pihole-health.service_tmp
	mv pihole-health.service_tmp /etc/systemd/system/pihole-health.service
	cp pihole-health.timer /etc/systemd/system/
	systemctl daemon-reload
	systemctl enable pihole-health.service
	systemctl enable pihole-health.timer
	systemctl start pihole-health.timer

install: venv systemd

health-check:
	./venv/bin/python pihole-health.py \
		--pass-url ${pass_url} \
		--pihole-ip ${pihole_ip} \
		--test-domain ${test_domain} \
		--test-domain-ip ${test_domain_ip}

clean-venv:
	rm -rf venv

clean-systemd:
	systemctl daemon-reload
	systemctl stop pihole-health.timer pihole-health.service
	systemctl disable pihole-health.timer pihole-health.service
	rm /etc/systemd/system/pihole-health.timer
	rm /etc/systemd/system/pihole-health.service
	systemctl daemon-reload
	systemctl reset-failed

clean: clean-venv clean-systemd
