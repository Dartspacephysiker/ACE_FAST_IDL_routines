;I wanna know who can be neg and who can't

dataDir = '/SPENCEdata/Research/Cusp/ACE_FAST/scripts_for_processing_Dartmouth_data/'
dbFile = 'Dartdb_02282015--500-14999--maximus--cleaned.sav'
restore,dataDir+dbFile

maxTags=tag_names(maximus)
nTags=n_elements(maxTags)
maxNegStruct={tagName:make_array(nTags,/STRING),hasNegs:make_array(nTags)}

OPENW,lun,'where_maximus_has_negs.txt',/get_lun
PRINTF,lun,'Tag name                                           Has negs?'

FOR i=0,nTags-1 DO BEGIN

   tempNeg=WHERE(maximus.(i) LT 0)

   maxNegStruct.tagName[i]=maxTags[i]
   maxNegStruct.hasNegs[i]=(tempNeg[0] EQ -1) ? 0 : 1
   
   PRINTF,lun,format='(A0,T50,I0)',maxNegStruct.tagName[i],maxNegStruct.hasNegs[i]
   PRINTF,lun,''

ENDFOR

CLOSE,lun