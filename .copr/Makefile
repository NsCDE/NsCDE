srpm:
	dnf -y install rpm-build rpmdevtools
	spectool -g -R "$(spec)"
	rpmbuild -bs \
		--define "_srcrpmdir $(outdir)" \
		"$(spec)"
