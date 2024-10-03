models  = devtlb devtlb_tip devtlb_ipu devtlb_vpu
regress_models = $(models)

.PHONY: slang build regress

slang:
	$(MAKE) -C $(WORKAREA)/verif/slang

build: slang
	$(MAKE) -C $(WORKAREA)/verif/vcssim

regress: $(regress_models)

$(regress_models):
	simregress -ld -model $@ -Q /DCG/CCT/RTL/priority
