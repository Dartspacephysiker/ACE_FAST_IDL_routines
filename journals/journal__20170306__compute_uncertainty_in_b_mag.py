# 2017/03/06
# def journal__20170306__compute_uncertainty_in_parallel_eflux():
from sympy import *             #
import sympy as sp
# qpar depends on hpar, vpar, vprp, ppar, pprp
# define all variables as sympy symbols
bx, by, bz = symbols('bx by bz')
sbx_bx, sbx_by, sbx_bz = symbols('sbx_bx sbx_by sbx_bz')
sby_bx, sby_by, sby_bz = symbols('sby_bx sby_by sby_bz')
sbz_bx, sbz_by, sbz_bz = symbols('sbz_bx sbz_by sbz_bz')
vlist = [bx, by, bz]
sigsbx = [sbx_bx, sbx_by, sbx_bz]
sigsby = [sby_bx, sby_by, sby_bz]
sigsbz = [sbz_bx, sbz_by, sbz_bz]
sigsmat = [sigsbx, sigsby, sigsbz]

bMag = sqrt(bx**2 + by**2 + bz**2)  # Magnitude of B

pdiffs = [diff(bMag, var) for var in vlist]
# pdiffssq = [pdiffs * diff(bMag, var) for var in vlist]
pdiffssq = []
pIter = iter(pdiffs)
for i in pIter:
    tmplist = [i * diff(bMag, var) for var in vlist]
    pdiffssq.append(tmplist)

# each member of the list 'exprlines' represents dbMag/db_i *
# SUM(dbMag/db_j for b_j in {hpar, vpar, vprp, ppar, pprp, pparprp})
#
# In other words, if we sum every element of exprlines, we get back
# SUM(dbMag/db_i * dbMag/db_j*sigma__b_i__b_j for b_i,b_j in {bx, by, bz})
count = 0
pIter = iter(pdiffssq)
exprlines = []
for pdiffprodrow in pIter:
    tmpline = sum([thisprod * thissigma for (thisprod, thissigma)
                   in zip(pdiffprodrow, sigsmat[count])])
    exprlines.append(tmpline)
    count += 1

totexpr = simplify(sum(exprlines))

# Print the product dbMag/db_i * dbMag/db_j
count = 0
for i in pdiffssq:
    print('')
    print('**{!s}**'.format(vlist[count]))
    count2 = 0
    for j in i:
        print('{!s:30}: {!s}'.format(
            '[{:2},{:2}] d{}*d{}'.format(count, count2, vlist[count], vlist[count2]), j))
        count2 += 1
    count += 1
lines = [a + b + c for (a, b, c) in zip(pdiffssq[0], pdiffssq[1], pdiffssq[2])]

# Substitutions--kill identical diag terms
# killRedunds = ((sby_bx, sbx_by),
#                (sbz_bx, sbx_bz),
#                (sbz_by, sby_bz))
s2bx, s2by, s2bz = symbols('s2bx s2by s2bz')
killRedunds = ((sby_bx, sbx_by),
               (sbz_bx, sbx_bz),
               (sbz_by, sby_bz),
               (sbx_bx, s2bx),
               (sby_by, s2by),
               (sbz_bz, s2bz))

print('')
print('En final:')
print(totexpr.subs(killRedunds))
print(simplify(totexpr.subs(killRedunds)))
