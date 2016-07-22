default: up provision app

up:
	@vagrant up

provision:
	@ansible-playbook -i plays/inventory/vagrant.py plays/init.yml

destroy:
	@vagrant destroy -f

app:
	@ansible-playbook -i plays/inventory/vagrant.py plays/app.yml

redo: destroy default
