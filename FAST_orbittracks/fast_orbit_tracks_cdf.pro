;Open 'er up
file="FAST_orbittracks.cdf"
id = CDF_OPEN(file)
inquire=CDF_INQUIRE(id)
help,inquire,/str
varinq=CDF_VARINQ(id)