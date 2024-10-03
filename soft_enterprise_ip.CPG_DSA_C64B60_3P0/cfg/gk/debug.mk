#!/usr/intel/bin/gmake -f

GKUTILS = /p/hdk/rtl/proj_tools/gatekeeper_utils/1.01.104/gk-utils.pl
ROOT    = $(shell git root)

export CTH_PERL5LIB /nfs/site/proj/hdk/pu_tu/prd/liteinfra/1.3.p01/commonFlow/lib/perl

export GK_MODELROOT        = $(ROOT)
export GK_WORKSPACE        = $(ROOT)
export GK_UTILS_CONFIG_DIR = $(ROOT)/cfg
export GK_CONFIG_DIR       = /p/hdk/pu_tu/prd/gatekeeper_configs/cae/latest/cth/pdv/cct/

export GK_PROJECT = cct


export GK_CLUSTER   = dsa
export GK_STEPPING  = eip
export GK_BRANCH    = master
export GK_MODELNAME = model

export GK_EVENTTYPE
export GK_EVENT

export NB_POOL_GK_OVERRIDE = $(EC_SITE)_normal

define ABOUT

A way to audit changes to GkUtils.cfg
	1. generate a reference xml file
		make xml > old.xml
	2. edit ../GkUtils.cfg
	3. regenerate the xml
		make xml > new.xml
	4. compare
		meld old.xml new.xml

Valid recipes:
	make filter.xml
	make integrate.xml
	make release.xml
	make post-release.xml

	make xml
		# does all 4
endef

export ABOUT

about:
	@echo "$$ABOUT"

filter.%:       GK_EVENTTYPE = filter
filter.%:       GK_EVENT     = filter
integrate.%:    GK_EVENTTYPE = turnin
integrate.%:    GK_EVENT     = integrate
release.%:      GK_EVENTTYPE = release
release.%:      GK_EVENT     = release
post-release.%: GK_EVENTTYPE = post-release
post-release.%: GK_EVENT     = post-release
drop.%:         GK_EVENTTYPE = drop
drop.%:         GK_EVENT     = drop
mock.%:         GK_EVENTTYPE = mock
mock.%:         GK_EVENT     = mock

FILTER = sed -e 's/cth_psetup.[0-9]*.env/cth_psetup.PID.env/'

../../GATEKEEPER:
	@echo Creating directory where scratch work goes
	mkdir -p ../../GATEKEEPER

%.xml: ../../GATEKEEPER
	@echo "==== $* ==== ("
	$(GKUTILS) -env_setup cth_psetup -no_run -recipe_xml | $(FILTER)
	@echo "==== $* ==== )"

%.breakout:
	./debug.mk       filter.xml | perl break.pl $*
	./debug.mk    integrate.xml | perl break.pl $*
	./debug.mk      release.xml | perl break.pl $*
	./debug.mk post-release.xml | perl break.pl $*
	./debug.mk         mock.xml | perl break.pl $*

xml: filter.xml integrate.xml release.xml post-release.xml drop.xml mock.xml


%.cmd: ../../GATEKEEPER
	@echo "==== $* ==== ("
	$(GKUTILS) -env_setup cth_psetup -no_run -commands_dump | $(FILTER)
	@echo "==== $* ==== )"

cmd: filter.cmd integrate.cmd release.cmd post-release.cmd drop.cmd




%.dot: ../../GATEKEEPER ../GkUtils.cfg debug.mk
	$(GKUTILS) -env_setup cth_psetup -no_run -dependency_graph > $*.dot
	@echo ""
	@echo ""
	@echo ""
	@echo "You need to edit the .dot file to remove clutter before running graphviz"

DOT = /usr/intel/bin/dot

%.png: %.dot
	$(DOT) -Tpng $*.dot -o $*.png


mock:         GK_EVENTTYPE = mock
mock:         GK_EVENT     = mock
mock:
	$(GKUTILS) -env_setup cth_psetup

